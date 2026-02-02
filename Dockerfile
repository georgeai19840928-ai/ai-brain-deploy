# 1. 使用 Node.js 20 環境
FROM node:20

# 2. 設定工作目錄
WORKDIR /app

# 3. [關鍵修正] 安裝 pnpm
# 官方專案依賴 pnpm 來執行 build 腳本，所以必須全域安裝
RUN npm install -g pnpm

# 4. 下載源碼
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# 5. [修正] 改用 pnpm 安裝依賴
# 這樣能確保跟官方開發環境完全一致，且速度更快
RUN pnpm install

# 6. 編譯 (Build)
# 這次 pnpm 已經裝好了，這裡就不會再報錯了
RUN pnpm run build

# 7. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789

# 8. 開放 Port
EXPOSE 18789

# 9. 啟動指令
# 編譯完成後，執行檔一定在 dist/index.js
CMD ["node", "dist/index.js", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]