# 実装規約

## 命名規則

ファイル名・モデル名はすべて PascalCase。パターンは `{Action}{Resource}{Type}` で、**動詞を先頭に置く**。

`main.tsp` の `@operationId`（`createUser` / `listUsers` など）と語順が一致するため、
オペレーションから対応するモデルを名前だけで引ける。ファイル一覧をアルファベット順に並べたときも
`Create...` / `Get...` / `List...` / `Update...` と操作単位でまとまる。

リソース名は**その操作が扱う件数に合わせる**。1件を扱う操作は単数（`GetUserResponse`）、
複数件を扱う一覧系は複数（`ListUsersResponse`）。

### Request

APIへの入力を表す。`{Action}{Resource}Request` の形式。

| 例 | 用途 |
|----|------|
| `CreateUserRequest` | ユーザー作成のリクエストボディ |
| `UpdateUserRequest` | ユーザー更新のリクエストボディ |

### Response

APIからの出力（レスポンスボディそのもの）。`{Action}{Resource}Response` の形式。
ラッパーではなくデータ本体なので、フィールドを直接持つ（[レスポンス設計方針](#レスポンス設計方針)を参照）。

| 例 | 用途 |
|----|------|
| `CreateUserResponse` | ユーザー作成のレスポンス（採番された `id`） |
| `GetUserResponse` | ユーザー取得のレスポンス |
| `ListUsersResponse` | ユーザー一覧のレスポンス（配列 + `pagination`） |

204 を返す操作（更新・削除など）はレスポンスボディが無いため、`Response` モデルを定義しない。

### Result

**一覧系レスポンスの配列要素のみ**に使う。`{Action}{Resource}Result` の形式。
1件返す操作は `Response` がそのままデータ本体なので `Result` を作らない。

| 例 | 用途 |
|----|------|
| `ListUsersResult` | ユーザー一覧の1件データ（配列の要素） |

### Pagination

一覧系レスポンスのページネーション情報。`{Action}{Resource}Pagination` の形式。
`common/pagination/` のスカラーから必要なものをピックして定義する。

| 例 | 用途 |
|----|------|
| `ListUsersPagination` | ユーザー一覧のページネーション情報 |

### スカラー型

概念をそのまま名前にする。

| 例 | 用途 |
|----|------|
| `Uuid` | UUID v7 |
| `TotalCount` | 総件数 |
| `CreatedAt` | 作成日時 |

## index.tsp の管理ルール（バレルエクスポート）

各フォルダの `index.tsp` はバレルエクスポートとして機能する。
新しい `.tsp` ファイルを追加したら、必ず同階層の `index.tsp` に import を追加する。
追加しないと型が認識されずビルドエラーになる。

```tsp
// 例: common/model/index.tsp に新しいスカラーを追加した場合
import "./NewScalar.tsp";
```

import の順序はアルファベット順に揃える。

## デコレータの使い方

### `@summary`

すべてのモデル・スカラーに必須。型名をそのまま記載する。

```tsp
@summary("CreateUserRequest")
model CreateUserRequest { ... }
```

### `@doc`

型の意味や制約を補足する必要があるときに記載する。型名だけで自明な場合は省略可。

```tsp
@doc("UUID v7")
scalar Uuid extends string;
```

### `@example`

スカラー型には必須。モデルには任意（複雑な型定義の理解を助ける場合に記載する）。

```tsp
// スカラー
@example("018eef15-1234-7123-8123-123456789abc")
scalar Uuid extends string;

// モデル
@example(#{
  status: 400,
  code: "4000",
  title: "リクエスト内容が不正です",
  errors: #[#{ field: "email", message: "メールアドレスの形式が不正です" }],
})
model BadRequestError { ... }
```

`utcDateTime` を継承した日時スカラー（`CreatedAt` / `UpdatedAt` など）は、
文字列リテラルではなく自分自身の `fromISO()` を使う。文字列を直接渡すと型エラーになる。

```tsp
// スカラー定義側
@example(CreatedAt.fromISO("2025-01-01T12:00:00Z"))
scalar CreatedAt extends utcDateTime;

// モデルの @example 内で使う場合
@example(#{ createdAt: CreatedAt.fromISO("2025-01-01T12:00:00Z") })
```

## common に入れる基準

`common/` は複数のサービス・リソースをまたいで共通で使用する型を置く。

- **OK**: `Uuid`, `Gender`, `CreatedAt`（どのドメインでも意味が変わらない型）
- **NG**: `FirstName`, `AddressLine1`（ユーザードメイン固有の型）

複数サービスで実際に共有が必要になったタイミングで移動する。「使いそう」な段階では移動しない。

## レスポンス設計方針

**エンベロープパターンは使わない。** レスポンスボディはデータ本体そのものとし、`result` / `meta` といった
汎用のラッパーで包まない。

### なぜエンベロープを使わないか

- **メタ情報の置き場は HTTP がすでに持っている。** `respondedAt` は HTTP の `Date` ヘッダと重複しており、
  ボディに入れる必然性がない。同様にステータス・キャッシュ・相関IDもヘッダの領分。
  「HTTP を使いながら HTTP を再実装する」形になっていた。
- **全クライアントが常に1段掘る。** `data.result.id` のように、意味のない階層を毎回通ることになる。
  OpenAPI から型やクライアントを自動生成する場合、この階層はそのまま生成物にも現れる。
- **スキーマがドメインを表さなくなる。** `GetUserResponse` が「ユーザー」ではなく「ユーザーを包んだ何か」に
  なり、`components/schemas` を読んでもドメインモデルが見えない。

ボディに入れる必然性がある情報（一覧のページネーションなど）だけを、リソース固有の名前付きフィールドとして持たせる。

### 単一リソースを返す場合

フィールドを直接持つ。

```json
{
  "id": "018eef15-1234-7123-8123-123456789abc",
  "firstName": "太郎",
  "lastName": "山田"
}
```

作成系（201）は採番された ID を返す。クライアントはこれを使って `GET /users/{id}` を呼べる。

```json
{ "id": "018eef15-1234-7123-8123-123456789abc" }
```

### 一覧を返す場合

配列とページネーションを同居させる必要があるため、ここだけオブジェクトになる。
ただし汎用の `result` ではなく、**リソース名をそのままフィールド名にする**（`users` / `products`）。
何の配列なのかがボディ単体で読み取れるようにするため。

```json
{
  "users": [...],
  "pagination": {
    "totalCount": 100,
    "totalPages": 10,
    "currentPage": 1,
    "perPage": 10
  }
}
```

配列要素の型は `{Action}{Resource}Result`（`ListUsersResult`）、
`pagination` の型は `{Action}{Resource}Pagination`（`ListUsersPagination`）としてリソースごとに定義し、
`common/pagination/` のスカラーから必要なものをピックする。

### ボディを返さない場合

更新・削除など、返すデータが無い操作は 204 とし、`Response` モデルを定義しない。

## エラーレスポンスの設計方針

### ラッパーで包まない

エラーレスポンスのボディは `error` オブジェクトでラップしない。HTTP ステータスコード（400・401・404 など）が
すでにエラーであることを表しているため、さらに包む意味がなく、クライアントの処理も複雑になるため。

```json
// NG: error でラップする
{ "error": { "code": "4000", "title": "..." } }

// OK: フラットに返す
{ "code": "4000", "title": "..." }
```

`response/ErrorResponses.tsp` の `@body error: BadRequestError` は**ラップではない**。
`@body` を付けたプロパティはボディそのものになり、プロパティ名（`error`）は JSON に現れない。

### `status` と `code` はリテラルで固定する

各エラーモデルは `status` と `code` を**リテラル型**で持つ。共有スカラーにして値を `@example` で示す方式は取らない。

```tsp
// NG: 値が契約に出ない
@example("4011")
scalar ErrorCode extends string;

model PasswordMismatchError {
  code: ErrorCode;
}

// OK: 値そのものが型
model PasswordMismatchError {
  status: 401;
  code: "4011";
}
```

`@example` は制約ではないため、前者は OpenAPI 上ただの `type: string` になる。
つまり**同じステータスの2つをクライアントが型で区別できない**。
エラーを別モデルに分けた目的そのものが契約に表れない状態になる。

リテラルにすると単一値の `enum` として出力される。

```yaml
code:
  type: string
  enum:
    - '4011'
```

下流の生成器はこれを `z.literal("4011")` や `code: "4011"` に落とせるため、
`code` を判別子とした**判別可能な直和（discriminated union）**として扱える。
TypeScript で `type Result = { kind: "ok" } | { kind: "err" }` と書くのと同じ発想。

例に挙げた `PasswordMismatchError`（401 / `4011`）は、サービス側に置くドメイン固有エラーの想定。
汎用の `UnauthorizedError`（401 / `4010`）と**ステータスが同じ**という点がここでの要点で、
`common/error/` の汎用エラーだけを見ていると必要性が見えにくい。

### `status` はステータス行とボディの両方に出す

ステータスがステータス行とボディの2箇所に出る重複は、承知のうえで受け入れる。
**エラーボディだけを取り回す読み手**（ログ・通知・画面へ渡した後の値）が、
HTTP の応答を持たないまま何が起きたかを判別できるようにするため。
RFC 9457 の Problem Details も同じ理由で `status` を本文に持つ。

ボディ側はリテラルに固定してあるため、ステータス行とのズレはクライアントの検証で落ちる。
このリポジトリは契約だけを持つので、二重に書く箇所が生じるとすれば実装側。
実装では1箇所で組み立ててステータス行とボディの両方に配ることを想定している。

### `title` と `errors[].message` は役割が違う

- `title`: **何が起きたか**を1行で表す。エラー単位で1つ。
- `errors[].message`: **どのフィールドが、なぜ駄目か**を表す。フィールド単位で複数。

同じ `message` という名前にすると、どちらの話か読む側が毎回考えることになるため名前を分けている。

`title` には型名（`"BadRequestError"`）ではなく、人間が読める文（`"リクエスト内容が不正です"`）を入れる。
型名は `code` と重複した情報であり、そのまま画面に出せない。

## エラーレスポンスの構造

```json
{
  "status": 404,
  "code": "4040",
  "title": "指定されたリソースは存在しません"
}
```

`BadRequestError` のみ `errors` を持つ（オプショナル）。
「どのフィールドが、なぜ駄目か」を返したいエラーが他に出てきた場合も同じ形で追加する。

```json
{
  "status": 400,
  "code": "4000",
  "title": "リクエスト内容が不正です",
  "errors": [
    { "field": "email", "message": "メールアドレスの形式が不正です" }
  ]
}
```

500系もボディを返す。クライアントの受け口が全ステータスで同形になり、
「500 だけ分岐が別」を無くせるため。ただし原因（例外・スタックトレース等）は露出せず、
ログなど内部利用に留める。

```json
{
  "status": 500,
  "code": "5000",
  "title": "サーバーで予期せぬエラーが発生しました"
}
```

## エラーコード体系

- 先頭3桁: HTTP ステータスコード
- 以降: インクリメント（サービス・ドメイン固有エラーの連番）

```
4000 → 400系の汎用エラー
4001 → 400系の固有エラー1番目
4040 → 404系の汎用エラー
4041 → 404系の固有エラー1番目
```

`common/error/` には汎用エラーのみを置く。

| モデル | status | code |
|--------|--------|------|
| `BadRequestError` | 400 | `4000` |
| `UnauthorizedError` | 401 | `4010` |
| `ForbiddenError` | 403 | `4030` |
| `ResourceNotFoundError` | 404 | `4040` |
| `ConflictError` | 409 | `4090` |
| `InternalServerError` | 500 | `5000` |

ドメイン固有のエラー（「メールアドレスが既に使用されている」など）は、
汎用エラーと同じ形のモデルを**サービス側**に定義し、連番を振る（`4091` など）。
汎用の 409 で足りる衝突と、分岐させたい衝突を、クライアントが `code` で見分けられるようにするため。

## tspconfig.yaml の構成ルール

各サービスの `tspconfig.yaml` は以下の形式で作成する。

```yaml
kind: project
entrypoint: main.tsp
emit:
  - "@typespec/openapi3"
options:
  "@typespec/openapi3":
    emitter-output-dir: "{cwd}/dist"
    output-file: "{service-name}-openapi.yaml"
    openapi-versions:
      - "3.2.0"
```

### `kind: project`

TypeSpec 1.13.0 で追加されたフィールド。このディレクトリがプロジェクトの境界であることを宣言する。

設定することで以下の効果がある：

- **IDE 言語サーバーの精度向上**: `.tsp` ファイルを開いたとき、どのプロジェクトに属するかを正確に判定できるようになる
- **`--config` 使用時の自動継承**: `--config` で別の設定ファイルを指定した場合に `entrypoint` や `features` の設定を自動で引き継ぐ

### `entrypoint`

プロジェクトのエントリーポイントとなる `.tsp` ファイルを指定する。省略時のデフォルトは `main.tsp`。
このリポジトリでは常に `main.tsp` を使用するため、明示的に記載する。

### `openapi-versions`

出力する OpenAPI のバージョンを指定する。省略時のデフォルトは `3.0.0`。
このリポジトリでは全サービス `3.2.0` に統一する。

まず `3.0.0` ではなく `3.1.0` 以降を選ぶ理由は、JSON Schema draft 2020-12 への完全準拠にある：

- `nullable: true`（3.0 独自拡張）が消え、`type: [string, "null"]` で表現される
- `example`（単数）ではなく `examples`（複数形・JSON Schema 標準）で出力される

その上で `3.2.0` を選ぶ。3.2.0 は 3.1 の完全な上位互換で、既存の記述は 1 行も変えずにそのまま有効。
バージョン文字列を上げるだけで、必要になったときに以下を後から使える：

- **階層タグ**: `tags` に `parent` / `kind` / `summary` が入り、API が増えても分類が破綻しない
- **ストリーミング**: `itemSchema` により SSE (`text/event-stream`) や JSON Lines を型付きで記述できる
- **HTTP メソッドの拡張**: `QUERY` メソッドと、任意メソッドを書ける `additionalOperations`
- **OAuth 2.0 デバイス認可フロー** (RFC 8628) のサポート
- `querystring` パラメータロケーション、ドキュメント自身の基準 URI を示す `$self`

実測として、現時点のスキーマを `3.1.0` / `3.2.0` の両方で出力して差分を取ると、
`openapi:` の行以外は完全に一致する。つまり**今すぐの出力コストはゼロ**で、上げておく側に倒せる。

ツール側の対応状況には注意する。`docker-compose.yaml` の Swagger UI は `v5.32.0` をピンしており、
このリリースで 3.2.0 の基本サポートが入っているため `pnpm preview` は問題なく動く。
一方で 3.2.0 に未対応の周辺ツールもまだ存在するため、生成した YAML を別のツールへ渡す場合は
対応状況を確認する。

新サービスを追加するときも必ず `3.2.0` を指定し、既存サービスと出力形式を揃える。

## サービスの追加方法

1. `src/{service-name}/` フォルダを作成
2. `tspconfig.yaml` を作成（上記「tspconfig.yaml の構成ルール」を参照）
3. `main.tsp` を作成してルーティングを定義
4. `package.json` に `"build:{service-name}": "tsp compile src/{service-name}"` を追加
