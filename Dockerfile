# 1. 使用 Node.js 基礎映像檔
FROM node:20-slim

# 2. 設定工作目錄
WORKDIR /app

# 3. 安裝 OpenClaw (全域安裝)
RUN npm install -g openclaw

# 4. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789

# 5. 開放 Port
EXPOSE 18789

# 6. [關鍵修改] 使用 npx 啟動
# npx 會自動找到全域安裝的指令，不用擔心路徑問題
# 同時加上 --host 0.0.0.0 確保外部連得進來
CMD ["npx", "openclaw", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]