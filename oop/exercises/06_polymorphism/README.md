# 06: ポリモーフィズム

## 題材：通知システム

複数の通知手段（Email、Slack、SMS）に対応した通知システムを作ってください。

### 要件

#### Notifier（通知クラス）
- 3種類の通知クラスを作る：
  - `EmailNotifier` - `send(message)` で `"Sending Email: #{message}"` を返す
  - `SlackNotifier` - `send(message)` で `"Sending Slack: #{message}"` を返す
  - `SmsNotifier` - `send(message)` で `"Sending SMS: #{message}"` を返す

#### NotificationService（通知サービス）
- 初期化時に notifier を受け取る
- `notify(message)` で notifier の `send` を呼び出す

### 使用例

```ruby
email_service = NotificationService.new(EmailNotifier.new)
email_service.notify("Hello!")  # => "Sending Email: Hello!"

slack_service = NotificationService.new(SlackNotifier.new)
slack_service.notify("Hello!")  # => "Sending Slack: Hello!"

sms_service = NotificationService.new(SmsNotifier.new)
sms_service.notify("Hello!")    # => "Sending SMS: Hello!"
```

### 考えてほしいこと

1. **NotificationServiceはnotifierの「種類」を知っている？**
   - NotificationServiceのコードの中に「Email」「Slack」「SMS」という文字は出てくる？
   - なぜ知らなくていい？

2. **これまでのレッスンとのつながり**
   - 03の日報システム: TextFormatterとMarkdownFormatterは両方 `format` メソッドを持っていた
   - 05の車とエンジン: GasolineEngineとElectricEngineは両方 `start` メソッドを持っていた
   - この「同じメソッドを持っている」ことの意味は？

3. **新しい通知手段（LINE等）を追加したくなったら？**
   - 何を作る必要がある？
   - NotificationServiceは変更する必要がある？

4. **ダックタイピング**
   - Rubyでは「同じメソッドを持っていれば同じように扱える」
   - "If it walks like a duck and quacks like a duck, it must be a duck"
   - 型ではなく「振る舞い」で判断する

### ファイル

以下のファイルを作成してください：
- `email_notifier.rb`
- `slack_notifier.rb`
- `sms_notifier.rb`
- `notification_service.rb`

### テストの実行

```bash
cd oop
rspec spec/06_polymorphism/
```

### キーワード

調べてみよう：
- ポリモーフィズム（Polymorphism / 多態性）
- ダックタイピング（Duck Typing）
- インターフェース（振る舞いの契約）
- 開放閉鎖原則（OCP: Open-Closed Principle）
