# 1. 使用 Node.js 20 輕量版
FROM node:20-slim

# 2. 設定工作目錄
WORKDIR /app

# 3. [關鍵改變] 改用「本地安裝」 (Local Install)
# 這樣檔案一定會乖乖待在 /app/node_modules 裡，絕對找得到
RUN npm install openclaw

# 4. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789

# 5. 開放 Port
EXPOSE 18789

# 6. [終極啟動指令] 直接叫 Node 去執行該檔案
# 我們不依賴 path，直接指定絕對路徑，保證錯不了
CMD ["node", "node_modules/openclaw/dist/index.js", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]