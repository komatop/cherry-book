# 05: 継承 vs コンポジション

## 題材：車とエンジン

異なるエンジンを搭載できる車を設計してください。

### 要件

#### Engine（エンジン）
- `start` メソッドで起動メッセージを返す
- 2種類のエンジンがある：
  - `GasolineEngine` → `"Gasoline engine starting... Vroom!"` を返す
  - `ElectricEngine` → `"Electric engine starting... Whirr!"` を返す

#### Car（車）
- エンジンを持っている
- `start` メソッドでエンジンを起動し、その結果を返す

### 使用例

```ruby
gasoline_car = Car.new(GasolineEngine.new)
gasoline_car.start  # => "Gasoline engine starting... Vroom!"

electric_car = Car.new(ElectricEngine.new)
electric_car.start  # => "Electric engine starting... Whirr!"
```

### 考えてほしいこと

1. **継承で実装したら？**
   - `GasolineCar < Car` と `ElectricCar < Car` という設計もできる
   - これだと何が問題になる？

2. **is-a vs has-a**
   - 「ガソリン車は車**である**」（is-a）
   - 「車はエンジンを**持っている**」（has-a）
   - どちらの表現がより柔軟？

3. **エンジンを交換したくなったら？**
   - 継承の場合、ガソリン車を電気自動車に変えるには？
   - コンポジションの場合、エンジンを交換するには？

4. **新しいエンジン（水素エンジン等）を追加したくなったら？**
   - 継承の場合、何を作る必要がある？
   - コンポジションの場合、何を作る必要がある？

### ファイル

以下のファイルを作成してください：
- `gasoline_engine.rb` - ガソリンエンジン
- `electric_engine.rb` - 電気エンジン
- `car.rb` - 車

### テストの実行

```bash
cd oop
rspec spec/05_inheritance_vs_composition/
```

### キーワード

調べてみよう：
- 継承（Inheritance）
- コンポジション（Composition）
- 「継承より委譲を好め」（Favor composition over inheritance）
- is-a関係 vs has-a関係
