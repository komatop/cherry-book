# レッスン03: セッション認証の仕組み

## このレッスンで考えること

- HTTPはステートレス。なのに「ログイン状態」をどう維持している？
- Cookie はどのタイミングで送られる？
- CSRF攻撃はなぜ成立する？どう防ぐ？

---

## 1. HTTPはステートレス

HTTPは**ステートレス**なプロトコル。

各リクエストは独立しており、サーバーは「さっきのリクエストと同じ人だ」とは分からない。

```
リクエスト1: GET /home
リクエスト2: GET /profile

→ サーバーから見ると、これが同じ人かどうか分からない
```

でも「ログイン状態」は維持されている。どうやって？

---

## 2. セッションの仕組み

### 基本的な流れ

```
1. ユーザーがログイン（ID/パスワード送信）

2. サーバーが認証成功を確認
   → セッションを作成（サーバー側に状態を保存）
   → セッションIDを発行

3. サーバーがレスポンスヘッダーで Cookie を設定
   Set-Cookie: session_id=abc123; HttpOnly; Secure

4. 以降のリクエストでブラウザが自動的に Cookie を送信
   Cookie: session_id=abc123

5. サーバーはセッションIDから「誰か」を特定
```

### ポイント

- **サーバー側**にセッションデータを保存（ユーザーID、権限など）
- **クライアント側**にはセッションIDだけを渡す
- セッションIDは「チケット」のようなもの

---

## 3. Cookie の属性

Cookie にはセキュリティに関わる重要な属性がある。

### HttpOnly

```
Set-Cookie: session_id=abc123; HttpOnly
```

JavaScript から Cookie にアクセスできなくなる。

```javascript
document.cookie  // session_id は見えない
```

**なぜ必要？** XSS攻撃でセッションIDを盗まれるのを防ぐ。

### Secure

```
Set-Cookie: session_id=abc123; Secure
```

HTTPS 通信でのみ Cookie を送信する。

**なぜ必要？** HTTP（平文）で送信すると盗聴される可能性がある。

### SameSite

```
Set-Cookie: session_id=abc123; SameSite=Lax
```

クロスサイトリクエストで Cookie を送信するかどうかを制御。

| 値 | 動作 |
|----|------|
| Strict | 同一サイトからのリクエストのみ Cookie を送信 |
| Lax | 同一サイト + トップレベルナビゲーション（リンククリック等）で送信 |
| None | 常に送信（Secure 必須） |

**なぜ必要？** CSRF攻撃を防ぐ。

---

## 4. CSRF攻撃の仕組み

レッスン01で触れたCSRF。セッション認証と組み合わせて詳しく見る。

### 攻撃シナリオ

```
前提: ユーザーが bank.example.com にログイン中
      （ブラウザに session_id Cookie が保存されている）

1. ユーザーが evil.example.net を訪問

2. evil.example.net に以下のHTMLがある：
   <form action="https://bank.example.com/transfer" method="POST">
     <input type="hidden" name="to" value="attacker">
     <input type="hidden" name="amount" value="100000">
   </form>
   <script>document.forms[0].submit();</script>

3. フォームが自動送信される
   → ブラウザは bank.example.com への Cookie を自動付与
   → サーバーは正規ユーザーからのリクエストだと判断
   → 送金が実行される
```

### なぜ成立するか

- ブラウザは**リクエスト先のドメイン**の Cookie を自動送信する
- サーバーは Cookie があれば「ログイン済み」と判断する
- 攻撃者はリクエストを**送るだけ**でよい（レスポンスは読めなくてもいい）

---

## 5. CSRF対策

### 対策1: CSRFトークン

```
1. サーバーがフォームに一意のトークンを埋め込む
   <input type="hidden" name="csrf_token" value="xyz789">

2. サーバーはトークンを検証
   - トークンがない → 拒否
   - トークンが不正 → 拒否

3. 攻撃者はトークンを知らないので、正しいリクエストを作れない
```

**なぜ攻撃者はトークンを取得できない？**
→ Same-Origin Policy でレスポンスを読めないから（レッスン01で学んだ）

### 対策2: SameSite Cookie

```
Set-Cookie: session_id=abc123; SameSite=Lax
```

別サイトからのリクエストには Cookie を送らない。
Cookie が送られなければ、サーバーは「未ログイン」として扱う。

### 対策3: Referer / Origin ヘッダーの検証

リクエストがどこから来たかをヘッダーで確認する。

```
Origin: https://evil.example.net
→ 自サイトからではないので拒否
```

ただし、ヘッダーは省略されることがあるので、これだけに頼るのは危険。

---

## 6. セッションのセキュリティ考慮事項

### セッションIDの推測防止

```
悪い例: session_id=user_1, session_id=user_2（連番）
良い例: session_id=a8f3k2m9x... （十分にランダム）
```

推測可能なIDは、他人のセッションを乗っ取られる。

### セッションの有効期限

```
Set-Cookie: session_id=abc123; Max-Age=3600  # 1時間
```

永続的なセッションはリスクが高い。適切な期限を設定する。

### ログアウト時の処理

- サーバー側でセッションを削除する
- Cookie も削除する

片方だけでは不十分。

---

## 確認問題

### Q1. ステートレスとセッション

「HTTPはステートレス」なのに、セッションで状態を管理している。
これは矛盾しているか？ 自分の言葉で説明せよ。

### Q2. Cookie の属性

以下の Cookie 設定には、セキュリティ上の問題がある。何が問題か？

```
Set-Cookie: session_id=abc123
```

（ヒント: 何の属性もついていない）

### Q3. CSRF と SameSite

SameSite=Strict にすると CSRF を完全に防げる。
しかし、実際には Lax がよく使われる。なぜ Strict ではなく Lax なのか？

（ヒント: ユーザー体験を考えてみる）

### Q4. 複合的な理解

あなたは銀行のWebアプリを開発している。以下の状況で何が起きるか説明せよ：

1. ユーザーが銀行サイトにログイン済み
2. Cookie は `SameSite=None; Secure` で設定されている
3. CSRFトークンは実装されていない
4. ユーザーが悪意あるサイトのリンクをクリック

---

回答を送ってくれたら、一緒に議論しよう。
