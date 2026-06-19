---
name: flutter-vscode-test
description: >-
  Write VM tests for flutter_vscode controllers without a webview. Use when
  testing @VSCodeCommand round-trips, request/response correlation, or
  timeout behavior.
---

# Test Controllers (flutter_vscode)

Test generated controller logic on the Dart VM without a VS Code webview.

## Setup

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_vscode/runtime.dart';
import 'package:my_extension/vscode_api.dart';

void main() {
  tearDown(VSCodeControllerBase.debugClearPendingRequests);

  test('inputBox waits for host response', () async {
    VSCodeControllerBase.debugRequestIdFactory = () => 'req-input';
    final api = createVSCodeApi();
    final future = api.inputBox({'prompt': 'Name?'});

    VSCodeControllerBase.handleMessage(<String, dynamic>{
      'requestId': 'req-input',
      'result': 'Ada',
    });

    expect(await future, 'Ada');
  });
}
```

## APIs

| API | Purpose |
|---|---|
| `debugRequestIdFactory` | Fix request id for deterministic tests |
| `handleMessage` | Simulate extension host response |
| `debugClearPendingRequests` | Reset pending state in `tearDown` |
| `debugResponseTimeout` | Adjust timeout for slow tests |

## Fire-and-Forget Commands

`Future<void>` / `void` commands do not wait for response:

```dart
await api.info('hello'); // completes without handleMessage
```

## Error Path

```dart
VSCodeControllerBase.handleMessage({
  'requestId': 'req-1',
  'error': 'command failed',
});
// future completes with Exception
```

## Timeout Path

```dart
VSCodeControllerBase.debugResponseTimeout = Duration(milliseconds: 50);
// don't call handleMessage — expect TimeoutException
```

## Reference

See `example/test/api_controller_test.dart` in the flutter_vscode package.
