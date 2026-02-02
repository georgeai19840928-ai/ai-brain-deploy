# 1. 使用完整的 Node.js 環境 (不使用 slim，避免缺編譯工具)
FROM node:20

# 2. 設定工作目錄
WORKDIR /app

# 3. [關鍵] 直接從 GitHub 下載最新源碼
# 這樣我們就不受 npm registry 版本或結構的影響
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# 4. 安裝依賴
RUN npm install

# 5. [關鍵] 現場編譯 (Build)
# 這會產生我們夢寐以求的 dist/ 資料夾
RUN npm run build

# 6. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789

# 7. 開放 Port
EXPOSE 18789

# 8. 啟動指令
# 因為是我們剛剛自己 build 的，檔案一定在 dist/index.js
CMD ["node", "dist/index.js", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]