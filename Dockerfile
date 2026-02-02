# 1. [關鍵修正] 改用 Node.js 22 (符合 openclaw >= 22.0.0 的要求)
FROM node:22

# 2. 設定工作目錄
WORKDIR /app

# 3. 安裝 pnpm
RUN npm install -g pnpm

# 4. 下載源碼 (OpenClaw)
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# 5. 安裝依賴
RUN pnpm install

# 6. 編譯 (Build)
RUN pnpm run build

# 7. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789

# 8. 開放 Port
EXPOSE 18789

# 9. 啟動指令
CMD ["node", "dist/index.js", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]