# Rails リファクタリング練習

オブジェクト指向の原則を使って、Railsのレガシーコードをリファクタリングする練習環境。

## セットアップ

### 1. Railsアプリの作成（初回のみ）

```bash
# リポジトリのルートで実行
docker compose run --rm web bash -c "gem install rails && rails new . --database=mysql --skip-git --force"
```

### 2. database.ymlの設定

`config/database.yml` を以下のように編集：

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  host: <%= ENV.fetch("DATABASE_HOST") { "localhost" } %>
  username: <%= ENV.fetch("DATABASE_USER") { "root" } %>
  password: <%= ENV.fetch("DATABASE_PASSWORD") { "" } %>

development:
  <<: *default
  database: rails_refactoring_development

test:
  <<: *default
  database: rails_refactoring_test
```

### 3. コンテナの起動

```bash
docker compose up -d
```

### 4. データベースの作成

```bash
docker compose exec web rails db:create
```

### 5. 動作確認

http://localhost:3000 にアクセス

## 練習問題

| # | テーマ | 状態 |
|---|--------|------|
| R1 | Fat Controller | 未着手 |
| R2 | Feature Envy | 未着手 |
| R3 | Callback地獄 | 未着手 |
| R4 | 条件分岐の乱用 | 未着手 |
| R5 | 貧血ドメインモデル | 未着手 |

## コマンド

```bash
# サーバー起動
docker compose up

# コンソール
docker compose exec web rails console

# テスト実行
docker compose exec web rspec

# マイグレーション
docker compose exec web rails db:migrate
```
