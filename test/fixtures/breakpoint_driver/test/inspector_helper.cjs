'use strict';

// Out-of-process debugger client for the breakpoint gate. The Extension Host
// pauses wholesale when a breakpoint hits, so the driver inside it cannot
// observe its own pause — this helper connects to the host's inspector port
// from a separate plain-Node process, arms the mapped breakpoints, records
// the pause, and resumes execution. It speaks raw Chrome DevTools Protocol
// over a hand-rolled WebSocket client (node:http upgrade + RFC 6455 text
// frames) so the driver needs zero npm dependencies.

const crypto = require('node:crypto');
const fs = require('node:fs');
const http = require('node:http');
const path = require('node:path');

const WEBSOCKET_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';

function log(message) {
  console.log(message);
}

function writeJsonAtomically(filePath, value) {
  const temporaryPath = `${filePath}.tmp`;
  fs.writeFileSync(temporaryPath, JSON.stringify(value, null, 2));
  fs.renameSync(temporaryPath, filePath);
}

function delay(milliseconds) {
  return new Promise((resolve) => setTimeout(resolve, milliseconds));
}

function httpGetJson(url) {
  return new Promise((resolve, reject) => {
    const request = http.get(url, (response) => {
      const chunks = [];
      response.on('data', (chunk) => chunks.push(chunk));
      response.on('end', () => {
        try {
          resolve(JSON.parse(Buffer.concat(chunks).toString('utf8')));
        } catch (error) {
          reject(error);
        }
      });
    });
    request.on('error', reject);
  });
}

/** Minimal RFC 6455 client connection: text frames, ping/pong, close. */
class WebSocketConnection {
  constructor(socket) {
    this.socket = socket;
    this.buffer = Buffer.alloc(0);
    this.fragments = [];
    this.onMessage = null;
    socket.on('data', (chunk) => {
      this.buffer = Buffer.concat([this.buffer, chunk]);
      this.drainFrames();
    });
  }

  drainFrames() {
    for (;;) {
      if (this.buffer.length < 2) {
        return;
      }
      const finAndOpcode = this.buffer[0];
      const maskAndLength = this.buffer[1];
      const fin = (finAndOpcode & 0x80) !== 0;
      const opcode = finAndOpcode & 0x0f;
      const masked = (maskAndLength & 0x80) !== 0;
      let length = maskAndLength & 0x7f;
      let offset = 2;
      if (length === 126) {
        if (this.buffer.length < 4) {
          return;
        }
        length = this.buffer.readUInt16BE(2);
        offset = 4;
      } else if (length === 127) {
        if (this.buffer.length < 10) {
          return;
        }
        length = Number(this.buffer.readBigUInt64BE(2));
        offset = 10;
      }
      const maskOffset = offset;
      if (masked) {
        offset += 4;
      }
      if (this.buffer.length < offset + length) {
        return;
      }
      let payload = this.buffer.subarray(offset, offset + length);
      if (masked) {
        const mask = this.buffer.subarray(maskOffset, maskOffset + 4);
        payload = Buffer.from(payload);
        for (let index = 0; index < payload.length; index += 1) {
          payload[index] ^= mask[index & 3];
        }
      }
      this.buffer = this.buffer.subarray(offset + length);
      if (opcode === 0x9) {
        this.sendFrame(0xa, payload);
        continue;
      }
      if (opcode === 0x8) {
        this.socket.end();
        continue;
      }
      if (opcode === 0x0 || opcode === 0x1 || opcode === 0x2) {
        this.fragments.push(payload);
        if (fin) {
          const message = Buffer.concat(this.fragments).toString('utf8');
          this.fragments = [];
          if (this.onMessage) {
            this.onMessage(message);
          }
        }
      }
    }
  }

  sendText(text) {
    this.sendFrame(0x1, Buffer.from(text, 'utf8'));
  }

  sendFrame(opcode, payload) {
    // Client-to-server frames must be masked (RFC 6455 section 5.3).
    const mask = crypto.randomBytes(4);
    let header;
    if (payload.length < 126) {
      header = Buffer.from([0x80 | opcode, 0x80 | payload.length]);
    } else if (payload.length < 65536) {
      header = Buffer.alloc(4);
      header[0] = 0x80 | opcode;
      header[1] = 0x80 | 126;
      header.writeUInt16BE(payload.length, 2);
    } else {
      header = Buffer.alloc(10);
      header[0] = 0x80 | opcode;
      header[1] = 0x80 | 127;
      header.writeBigUInt64BE(BigInt(payload.length), 2);
    }
    const maskedPayload = Buffer.from(payload);
    for (let index = 0; index < maskedPayload.length; index += 1) {
      maskedPayload[index] ^= mask[index & 3];
    }
    this.socket.write(Buffer.concat([header, mask, maskedPayload]));
  }
}

function connectWebSocket(webSocketUrl) {
  return new Promise((resolve, reject) => {
    const url = new URL(webSocketUrl);
    const key = crypto.randomBytes(16).toString('base64');
    const request = http.request({
      host: url.hostname,
      port: url.port,
      path: `${url.pathname}${url.search}`,
      headers: {
        Connection: 'Upgrade',
        Upgrade: 'websocket',
        'Sec-WebSocket-Version': '13',
        'Sec-WebSocket-Key': key,
      },
    });
    request.on('upgrade', (response, socket) => {
      const expectedAccept = crypto
        .createHash('sha1')
        .update(key + WEBSOCKET_GUID)
        .digest('base64');
      if (response.headers['sec-websocket-accept'] !== expectedAccept) {
        socket.destroy();
        reject(new Error('WebSocket handshake returned a bad accept key'));
        return;
      }
      socket.setNoDelay(true);
      resolve(new WebSocketConnection(socket));
    });
    request.on('response', (response) => {
      reject(
        new Error(`WebSocket upgrade refused: HTTP ${response.statusCode}`),
      );
    });
    request.on('error', reject);
    request.end();
  });
}

/** Chrome DevTools Protocol session over the raw WebSocket connection. */
class InspectorSession {
  constructor(connection) {
    this.connection = connection;
    this.nextId = 1;
    this.pending = new Map();
    this.onEvent = null;
    connection.onMessage = (text) => {
      const message = JSON.parse(text);
      if (message.id !== undefined) {
        const settlers = this.pending.get(message.id);
        if (settlers) {
          this.pending.delete(message.id);
          if (message.error) {
            settlers.reject(
              new Error(`${message.error.message ?? 'inspector error'}`),
            );
          } else {
            settlers.resolve(message.result);
          }
        }
        return;
      }
      if (this.onEvent) {
        this.onEvent(message.method, message.params ?? {});
      }
    };
  }

  send(method, params) {
    const id = this.nextId;
    this.nextId += 1;
    return new Promise((resolve, reject) => {
      this.pending.set(id, {resolve, reject});
      this.connection.sendText(JSON.stringify({id, method, params}));
    });
  }
}

async function discoverWebSocketUrl(inspectPort) {
  let lastError = null;
  for (let attempt = 0; attempt < 40; attempt += 1) {
    try {
      const targets = await httpGetJson(
        `http://127.0.0.1:${inspectPort}/json/list`,
      );
      const target = targets.find(
        (entry) => typeof entry.webSocketDebuggerUrl === 'string',
      );
      if (target) {
        return target.webSocketDebuggerUrl;
      }
      lastError = new Error('No inspector target exposes a debugger URL');
    } catch (error) {
      lastError = error;
    }
    await delay(500);
  }
  throw new Error(
    `Could not discover an inspector target on port ${inspectPort}: ` +
      `${lastError}`,
  );
}

async function main() {
  const configPath = process.argv[2];
  if (!configPath) {
    throw new Error('Usage: inspector_helper.cjs <config.json>');
  }
  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));
  const {
    inspectPort,
    scriptUrlSuffix,
    breakpointLocations,
    armedPath,
    resultPath,
    pauseTimeoutMs,
  } = config;

  const reportFailure = (reason) => {
    if (!fs.existsSync(resultPath)) {
      writeJsonAtomically(resultPath, {paused: false, reason});
    }
  };

  const webSocketUrl = await discoverWebSocketUrl(inspectPort);
  log(`connecting to ${webSocketUrl}`);
  const session = new InspectorSession(await connectWebSocket(webSocketUrl));

  const scriptUrlsById = new Map();
  let resolveScriptFound;
  const scriptFound = new Promise((resolve) => {
    resolveScriptFound = resolve;
  });
  let resolvePaused;
  const paused = new Promise((resolve) => {
    resolvePaused = resolve;
  });
  session.onEvent = (method, params) => {
    if (method === 'Debugger.scriptParsed') {
      scriptUrlsById.set(params.scriptId, params.url);
      if (
        typeof params.url === 'string' &&
        params.url.endsWith(scriptUrlSuffix)
      ) {
        resolveScriptFound(params.url);
      }
      return;
    }
    if (method === 'Debugger.paused') {
      resolvePaused(params);
    }
  };

  // Debugger.enable replays scriptParsed for scripts the host already
  // loaded, so the compiled bundle is discoverable even though the fixture
  // activated before this helper connected.
  await session.send('Debugger.enable', {});
  const scriptUrl = await Promise.race([
    scriptFound,
    delay(20000).then(() => {
      throw new Error(
        `No parsed script matched *${scriptUrlSuffix} within 20s`,
      );
    }),
  ]);
  log(`found ${scriptUrl}`);

  const breakpoints = [];
  for (const location of breakpointLocations) {
    try {
      const result = await session.send('Debugger.setBreakpointByUrl', {
        url: scriptUrl,
        lineNumber: location.lineNumber,
        columnNumber: location.columnNumber,
      });
      breakpoints.push({
        requested: location,
        breakpointId: result.breakpointId,
        resolvedLocations: result.locations.map((resolved) => ({
          lineNumber: resolved.lineNumber,
          columnNumber: resolved.columnNumber,
        })),
      });
    } catch (error) {
      // V8 rejects a second breakpoint at an already-covered location;
      // one bound breakpoint on the line is all the gate needs.
      log(`setBreakpointByUrl ${location.lineNumber}:` +
        `${location.columnNumber} rejected: ${error.message}`);
    }
  }
  if (breakpoints.length === 0) {
    reportFailure('Every setBreakpointByUrl call was rejected');
    process.exit(1);
  }
  log(`armed ${breakpoints.length} breakpoints`);
  writeJsonAtomically(armedPath, {scriptUrl, breakpoints});

  const pauseEvent = await Promise.race([
    paused,
    delay(pauseTimeoutMs).then(() => null),
  ]);
  if (pauseEvent === null) {
    reportFailure(
      `The Extension Host did not pause within ${pauseTimeoutMs}ms`,
    );
    process.exit(1);
  }

  const topFrame = pauseEvent.callFrames[0];
  const pausedLocation = {
    url:
      scriptUrlsById.get(topFrame.location.scriptId) ?? topFrame.url ?? '',
    lineNumber: topFrame.location.lineNumber,
    columnNumber: topFrame.location.columnNumber,
  };
  log(
    `paused at ${path.basename(pausedLocation.url)}:` +
      `${pausedLocation.lineNumber}:${pausedLocation.columnNumber}`,
  );
  // Resume before reporting: a paused Extension Host freezes the driver
  // that is waiting on the result file.
  await session.send('Debugger.resume', {});
  log('resumed the Extension Host');
  writeJsonAtomically(resultPath, {
    paused: true,
    pausedLocation,
    hitBreakpoints: pauseEvent.hitBreakpoints ?? [],
  });
  process.exit(0);
}

main().catch((error) => {
  console.error(error);
  try {
    const config = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
    if (!fs.existsSync(config.resultPath)) {
      writeJsonAtomically(config.resultPath, {
        paused: false,
        reason: `helper crashed: ${error.message}`,
      });
    }
  } catch {
    // The config itself was unreadable; the driver's timeout reports it.
  }
  process.exit(1);
});
