# 04: オブジェクト間の協調

## 題材：ショッピングカート

商品をカートに追加し、合計金額を計算するシステムを作ってください。

### 要件

#### Product（商品）
- 商品名（name）と価格（price）を持つ

#### Cart（カート）
- 商品を追加できる（`add`）
- カート内の商品一覧を取得できる（`items`）
- 合計金額を計算できる（`total_price`）

### 使用例

```ruby
cart = Cart.new

cart.add(Product.new(name: 'Apple', price: 150))
cart.add(Product.new(name: 'Banana', price: 100))
cart.add(Product.new(name: 'Orange', price: 200))

cart.items.size    # => 3
cart.total_price   # => 450
```

### 考えてほしいこと

1. **CartはProductの何を知っている必要がある？**
   - Cartが合計金額を計算するには、Productの何にアクセスする？
   - CartはProductの「名前」を知る必要がある？

2. **依存の方向**
   - CartはProductを知っている。ではProductはCartを知っている？
   - この「一方向の依存」は意図的。なぜだと思う？

3. **オブジェクト同士の会話**
   - `cart.total_price` を呼ぶと、内部で何が起きる？
   - CartがProductに「価格を教えて」と聞いている、と考えられる？

### ファイル

以下のファイルを作成してください：
- `product.rb` - 商品クラス
- `cart.rb` - カートクラス

### テストの実行

```bash
cd oop
rspec spec/04_collaboration/
```

### キーワード

調べてみよう：
- オブジェクト間のコラボレーション
- メッセージパッシング
- 依存関係（Dependency）
- Tell, Don't Ask（命令するな、聞け）
