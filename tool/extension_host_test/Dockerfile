FROM node:22-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      libasound2 \
      libatk-bridge2.0-0 \
      libatk1.0-0 \
      libatspi2.0-0 \
      libcairo2 \
      libcups2 \
      libdbus-1-3 \
      libdrm2 \
      libgbm1 \
      libglib2.0-0 \
      libgtk-3-0 \
      libnspr4 \
      libnss3 \
      libpango-1.0-0 \
      libx11-6 \
      libx11-xcb1 \
      libxcb1 \
      libxcomposite1 \
      libxdamage1 \
      libxext6 \
      libxfixes3 \
      libxkbcommon0 \
      libxrandr2 \
      xauth \
      xvfb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /runner

COPY tool/extension_host_test/package.json \
     tool/extension_host_test/package-lock.json ./
RUN npm ci

ENV NODE_PATH=/runner/node_modules
