# 1. 使用 Node.js 22
FROM node:22

# 2. 設定工作目錄
WORKDIR /app

# 3. 安裝 pnpm
RUN npm install -g pnpm

# 4. 下載源碼
RUN git clone --depth 1 https://github.com/openclaw/openclaw.git .

# 5. 安裝依賴
RUN pnpm install

# 6. 編譯
RUN pnpm run build

# 7. [關鍵新增] 直接建立設定檔 (雙重保險)
# 這樣就算啟動指令漏了參數，程式也能讀到這個檔
RUN echo '{"gateway": {"mode": "local"}}' > .openclawrc

# 8. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789
ENV HOST=0.0.0.0

# 9. 開放 Port
EXPOSE 18789

# 10. 啟動指令
# 我們已經有 .openclawrc 了，但參數還是帶著比較保險
CMD ["node", "dist/index.js", "gateway", "run", "--port", "18789", "--allow-unconfigured"]