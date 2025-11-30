# レッスン01: Same-Origin Policy と CORS

## このレッスンで考えること

- ブラウザはなぜ「他のサイトへのリクエスト」を制限するのか？
- その制限がないと、何が起きるのか？
- CORS は「制限を緩める」仕組み。なぜ緩める必要があるのか？

---

## 1. Same-Origin Policy とは

ブラウザには**Same-Origin Policy（同一オリジンポリシー）**というセキュリティ機構がある。

### オリジンの定義

「オリジン」は以下の3つの組み合わせで決まる：

- **スキーム**（プロトコル）: `http` or `https`
- **ホスト**: `example.com`
- **ポート**: `443`, `8080` など

例：
| URL | オリジン |
|-----|----------|
| `https://example.com/page` | `https://example.com` |
| `https://example.com:8080/page` | `https://example.com:8080` |
| `http://example.com/page` | `http://example.com` |

**ひとつでも違えば「別オリジン」になる。**

---

## 2. 何が制限されるのか

Same-Origin Policy は、**JavaScript からの「別オリジン」へのアクセス**を制限する。

### 制限されるもの

- `fetch()` や `XMLHttpRequest` で別オリジンにリクエストを送り、**レスポンスを読む**こと
- 別オリジンの `iframe` の中身を JavaScript で操作すること

### 制限されないもの

- `<img src="...">` で別オリジンの画像を表示する
- `<script src="...">` で別オリジンのJSを読み込む
- `<form action="...">` で別オリジンにPOSTする

ここが重要：**リクエストを「送る」ことは止められない。レスポンスを「読む」ことが制限される。**

---

## 3. なぜこの制限が必要なのか

### 攻撃シナリオを考える

あなたは `https://bank.example.com` にログイン中だとする。
ブラウザには銀行サイトの Cookie が保存されている。

このとき、悪意あるサイト `https://evil.example.net` を開いたとする。

もし Same-Origin Policy がなかったら：

```
evil.example.net の JavaScript が...
  ↓
fetch('https://bank.example.com/api/account')
  ↓
ブラウザは bank.example.com の Cookie を自動送信
  ↓
銀行のAPIが口座情報を返す
  ↓
evil.example.net の JavaScript がその情報を読み取れる
  ↓
攻撃者のサーバーに送信される
```

**これがSame-Origin Policyで防がれる。**

リクエスト自体は送れてしまう。しかし、**レスポンスを JavaScript で読むことがブロックされる**。

---

## 4. CORS とは

**Cross-Origin Resource Sharing（CORS）**は、Same-Origin Policy を**緩和する**仕組み。

### なぜ緩和が必要か

現代のWebでは：
- フロントエンド: `https://app.example.com`
- API: `https://api.example.com`

このように別オリジンに分かれることが多い。
Same-Origin Policy のままでは、自分のAPIにすらアクセスできない。

### CORS の仕組み

サーバー側が「このオリジンからのアクセスは許可する」と明示する。

```
レスポンスヘッダー:
Access-Control-Allow-Origin: https://app.example.com
```

ブラウザはこのヘッダーを見て、「許可されている」と判断し、JavaScript にレスポンスを渡す。

---

## 5. プリフライトリクエスト

単純でないリクエスト（PUT, DELETE、カスタムヘッダー付きなど）の場合、ブラウザは**事前確認**を行う。

```
1. ブラウザ → サーバー: OPTIONS リクエスト（プリフライト）
   「PUT で Content-Type: application/json を送りたいけど、いい？」

2. サーバー → ブラウザ:
   Access-Control-Allow-Methods: PUT
   Access-Control-Allow-Headers: Content-Type
   「OK」

3. ブラウザ → サーバー: 本来の PUT リクエスト
```

### なぜ事前確認するのか？

歴史的に、サーバーは「ブラウザからは GET/POST しか来ない」前提で作られていた。
いきなり DELETE が飛んできたら、対応できないサーバーがあるかもしれない。

プリフライトは「送っていい？」と確認する安全装置。

---

## 6. 資格情報付きリクエスト（credentials）

Cookie やHTTP認証情報を含むリクエストは、追加の設定が必要。

```javascript
fetch('https://api.example.com/data', {
  credentials: 'include'  // Cookie を送る
})
```

サーバー側も明示的に許可が必要：

```
Access-Control-Allow-Origin: https://app.example.com  # ワイルドカード(*) は使えない
Access-Control-Allow-Credentials: true
```

---

## 確認問題

以下の質問に答えてみてください。チャットで回答を送ってくれればOK。

### Q1. オリジンの判定

以下のURLのペアは「同一オリジン」か「別オリジン」か？理由も含めて答えよ。

1. `https://example.com/page1` と `https://example.com/page2`
2. `https://example.com` と `http://example.com`
3. `https://example.com` と `https://api.example.com`
4. `https://example.com:443` と `https://example.com`

### Q2. 攻撃シナリオ

Same-Origin Policy がなかった場合に可能になる攻撃を、自分の言葉で説明せよ。
「銀行サイト」以外の具体例を考えてみること。

### Q3. なぜ「送信」は止められないのか

Same-Origin Policy は「リクエストの送信」自体は止めない。止めるのは「レスポンスを読む」こと。
なぜこのような設計になっているのか、考えてみよ。

（ヒント: `<img>` や `<form>` のことを考えてみる）

### Q4. CORS の誤解

「CORS はセキュリティを強化する仕組み」という説明は正確か？
なぜそう言えるのか、または言えないのか、説明せよ。

---

回答を送ってくれたら、一緒に議論しよう。
