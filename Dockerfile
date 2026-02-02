# 1. 使用 Node.js 基礎映像檔
FROM node:20-slim

# 2. 安裝基礎工具 (確保有 find 和 bash)
RUN apt-get update && apt-get install -y findutils bash && rm -rf /var/lib/apt/lists/*

# 3. 設定工作目錄
WORKDIR /app

# 4. 安裝 OpenClaw
RUN npm install openclaw

# 5. 設定環境變數
ENV GATEWAY_MODE=local
ENV PORT=18789
EXPOSE 18789

# 6. [核心大招] 建立一個「自動導航」啟動腳本
# 這個腳本會自己去資料夾裡翻找 index.js，找到誰就跑誰
RUN echo '#!/bin/bash' > run.sh && \
    echo 'echo "🔍 Scanning for OpenClaw entry point..."' >> run.sh && \
    # 優先找 dist/index.js
    echo 'TARGET=$(find node_modules/openclaw -name "index.js" | grep "dist" | head -n 1)' >> run.sh && \
    # 如果找不到，就找任何一個 index.js
    echo 'if [ -z "$TARGET" ]; then TARGET=$(find node_modules/openclaw -name "index.js" | head -n 1); fi' >> run.sh && \
    # 如果還是找不到，列出目錄結構讓我們除錯
    echo 'if [ -z "$TARGET" ]; then echo "❌ File not found! Listing files:"; ls -R node_modules/openclaw; exit 1; fi' >> run.sh && \
    echo 'echo "🚀 Found core: $TARGET"' >> run.sh && \
    # 啟動！
    echo 'exec node "$TARGET" gateway run --port 18789 --host 0.0.0.0 --allow-unconfigured' >> run.sh && \
    chmod +x run.sh

# 7. 執行腳本
CMD ["/bin/bash", "run.sh"]