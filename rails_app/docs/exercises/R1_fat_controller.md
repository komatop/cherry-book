# R1: Fat Controller

## 概要

「Fat Controller」とは、コントローラーにビジネスロジックが集中してしまっているアンチパターンです。

Railsでは「Fat Model, Skinny Controller」という原則がありますが、この練習問題ではその原則に反したコードをリファクタリングします。

## 問題のコード

`app/controllers/orders_controller.rb` の `create` アクションを見てください。

このコントローラーには以下のロジックが詰め込まれています：

1. **在庫チェック** - 商品の在庫が足りているか確認
2. **合計金額計算** - 注文の合計金額を計算
3. **ポイント利用バリデーション** - 利用ポイントが妥当か確認
4. **支払い金額計算** - ポイント利用後の金額を計算
5. **獲得ポイント計算** - 購入で得られるポイントを計算
6. **在庫更新** - 商品の在庫を減らす
7. **ポイント更新** - ユーザーのポイントを更新

## 課題

このコントローラーをリファクタリングしてください。

### 制約

- **Serviceクラスは作らない**（`app/services/` ディレクトリを作らない）
- ロジックはモデル層に移動する
- コントローラーは「リクエストを受け取り、モデルに処理を委譲し、レスポンスを返す」だけにする

### ヒント

リファクタリング後のコントローラーは、こんなイメージになるはず：

```ruby
def create
  @user = User.find(params[:user_id])
  @order = @user.place_order(
    items: params[:items],
    use_points: params[:use_points].to_i
  )

  render json: { ... }, status: :created
rescue Order::InsufficientStockError => e
  render json: { error: e.message }, status: :unprocessable_entity
rescue Order::InvalidPointsError => e
  render json: { error: e.message }, status: :unprocessable_entity
end
```

## 考えてほしいこと

コードを書く前に、以下の問いについて考えてみてください：

1. **「在庫チェック」は誰の責務？**
   - コントローラー？Order？Product？

2. **「ポイント計算」は誰の責務？**
   - ポイント利用の判断は誰がする？
   - ポイント獲得の計算は誰がする？

3. **「合計金額計算」は誰の責務？**
   - Orderが自分の合計を知っているべき？
   - それとも外部から計算して渡す？

4. **トランザクション境界はどこ？**
   - 何を1つの処理単位として扱うべき？

5. **エラーハンドリングはどうする？**
   - 在庫不足やポイント不足をどう表現する？
   - 例外？戻り値？

## セットアップ

```bash
# マイグレーション実行
docker compose exec web rails db:migrate

# コンソールで動作確認
docker compose exec web rails console
```

```ruby
# テストデータ作成
user = User.create!(name: "テストユーザー", email: "test@example.com", points: 1000)
product1 = Product.create!(name: "りんご", price: 100, stock: 10)
product2 = Product.create!(name: "みかん", price: 80, stock: 20)
```

## 動作確認

```bash
# 注文作成（curlで確認）
curl -X POST http://localhost:3000/orders \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "use_points": 100,
    "items": [
      {"product_id": 1, "quantity": 2},
      {"product_id": 2, "quantity": 3}
    ]
  }'
```

## 評価ポイント

- [ ] コントローラーが薄くなっているか
- [ ] ビジネスロジックが適切なモデルに移動しているか
- [ ] Serviceクラスを使っていないか
- [ ] 各モデルの責務が明確か
- [ ] エラーハンドリングが適切か
