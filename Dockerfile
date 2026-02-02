# 使用最輕量的 Node.js 基礎映像檔
FROM node:20-slim

# 設定工作目錄
WORKDIR /app

# 安裝 OpenClaw (全域安裝)
# 這樣我們就不用管 package.json 那些囉嗦事了
RUN npm install -g openclaw

# 設定環境變數 (預設值)
ENV GATEWAY_MODE=local
ENV PORT=18789

# 開放 Port
EXPOSE 18789

# 啟動指令 (加上 --allow-unconfigured 讓它乖乖聽話)
CMD ["openclaw", "gateway", "run", "--port", "18789", "--host", "0.0.0.0", "--allow-unconfigured"]