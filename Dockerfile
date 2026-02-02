# 1. 使用 Node.js 22
FROM node:22

# 2. 設定工作目錄
WORKDIR /app

# 3. 安裝 pnpm
RUN npm install -g pnpm

# 4. 下載源碼
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# 5. 安裝依賴並編譯
RUN pnpm install && pnpm run build

# 6. [核心修改] 建立多重設定檔保險
# 確保程式無論讀哪個路徑都能看到 gateway.mode = local
RUN echo '{"gateway": {"mode": "local"}}' > .openclawrc && \
    mkdir -p config && \
    echo '{"gateway": {"mode": "local"}}' > config/config.json

# 7. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789
ENV HOST=0.0.0.0
ENV NODE_ENV=production

# 8. 開放 Port
EXPOSE 18789

# 9. [關鍵啟動指令] 
# 我們直接執行編譯後的 JS，不透過 openclaw 指令包裝，避免參數被過濾
CMD ["node", "dist/index.js", "gateway", "run", "--port", "18789", "--allow-unconfigured"]