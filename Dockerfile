# 1. Swift イメージをベースに使用
FROM swift:5.9 AS builder

# 2. 作業ディレクトリを作成
WORKDIR /app

# 3. システム環境を更新 & 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# 4. プロジェクトの依存関係をキャッシュするために、先に Package.swift をコピー
COPY Package.swift Package.resolved ./

# 5. 依存関係を解決 & ビルドキャッシュを活用
RUN swift package resolve

# 6. プロジェクトのソースコードをコピー
COPY . .

# 7. Vapor アプリをビルド
RUN swift build -c release --static-swift-stdlib

# 8. 実行用の軽量イメージを作成
FROM ubuntu:22.04 AS runtime

# 9. 必要なライブラリをインストール
RUN apt-get update && apt-get install -y \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

# 10. 作業ディレクトリを作成
WORKDIR /app

# 11. ビルド済みバイナリをコピー
COPY --from=builder /app/.build/release/Run /app/Run

# 12. ポートを開放
EXPOSE 8080

# 13. 実行
CMD ["./Run", "serve", "--hostname", "0.0.0.0", "--port", "8080"]