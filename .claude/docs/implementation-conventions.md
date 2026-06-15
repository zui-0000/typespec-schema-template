# 実装規約

## 命名規則

ファイル名・モデル名はすべて PascalCase。パターンは `{Domain}{Action}{Type}`。

### Request

APIへの入力を表す。`{Domain}{Action}Request` の形式。

| 例 | 用途 |
|----|------|
| `UserCreateRequest` | ユーザー作成のリクエストボディ |
| `UserUpdateRequest` | ユーザー更新のリクエストボディ |

### Response

APIからの出力全体を表す。`result` / `meta` / `pagination` をまとめるラッパー。`{Domain}{Action}Response` の形式。

| 例 | 用途 |
|----|------|
| `UserCreateResponse` | ユーザー作成のレスポンス全体 |
| `UserListResponse` | ユーザー一覧のレスポンス全体 |

### Result

Response の中のデータ本体。`{Domain}{Action}Result` の形式。

| 例 | 用途 |
|----|------|
| `UserGetResult` | ユーザー取得の1件データ |
| `UserListResult` | ユーザー一覧の1件データ（配列の要素） |

### Pagination

リスト系レスポンスのページネーション情報。`{Domain}ListPagination` の形式。
`common/pagination/` のスカラーから必要なものをピックして定義する。

| 例 | 用途 |
|----|------|
| `UserListPagination` | ユーザー一覧のページネーション情報 |

### Meta（common）

レスポンスメタデータ。`common/meta/` に定義し `Common{Type}Meta` の形式。

| 例 | 用途 |
|----|------|
| `CommonResponseMeta` | 全レスポンス共通のメタ情報（`respondedAt` など） |

### スカラー型

概念をそのまま名前にする。

| 例 | 用途 |
|----|------|
| `Uuid` | UUID v7 |
| `TotalCount` | 総件数 |
| `RespondedAt` | レスポンス日時 |

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
@summary("UserCreateRequest")
model UserCreateRequest { ... }
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
  errorCode: "4000",
  message: "BadRequestException",
  meta: #{ respondedAt: "2025-01-01T12:00:00Z" },
})
model BadRequestException { ... }
```

## common に入れる基準

`common/` は複数のサービス・リソースをまたいで共通で使用する型を置く。

- **OK**: `Uuid`, `Gender`, `RespondedAt`（どのドメインでも意味が変わらない型）
- **NG**: `FirstName`, `AddressLine1`（ユーザードメイン固有の型）

複数サービスで実際に共有が必要になったタイミングで移動する。「使いそう」な段階では移動しない。

## レスポンス設計方針

エンベロープパターンで設計する。レスポンスボディ全体をエンベロープとして扱い、「データ本体」と「メタ情報」を明確に分離する。

参考: https://theproductguy.in/blogs/json-api-response-format/

| フィールド | 役割 |
|-----------|------|
| `result` | データ本体 |
| `meta` | レスポンスメタデータ（`respondedAt` など） |
| `pagination` | ページネーション情報（リスト系のみ） |

`pagination` は `meta` にも `result` にも含めず独立したフィールドとして分離している。
`meta` は「レスポンス自体に関する情報」（いつ返したかなど）であるのに対し、`pagination` は「データセットに関する情報」（何件あるか・何ページ目か）であり、性質が異なるため。また、ページネーションが不要なエンドポイントでは `pagination` フィールドごと省略できるという利点もある。

## 成功レスポンスの設計方針

データ本体のフィールド名は `data` ではなく `result` を使用する。
フロントエンドで TanStack Query を使用する場合、レスポンスボディ全体が `data` としてラップされるため、フィールド名も `data` にすると `data.data` という参照になり冗長になるため。

```ts
// NG: data.data になる
const { data } = useQuery(...)
data.data.id

// OK: data.result でアクセスできる
const { data } = useQuery(...)
data.result.id
```

## 成功レスポンスの構造

```json
{
  "result": { ... },
  "meta": { "respondedAt": "2025-01-01T12:00:00Z" }
}
```

リスト系エンドポイントはページネーションを追加する。

```json
{
  "result": [...],
  "meta": { "respondedAt": "2025-01-01T12:00:00Z" },
  "pagination": {
    "totalCount": 100,
    "totalPages": 10,
    "currentPage": 1,
    "perPage": 10
  }
}
```

`pagination` の型はサービスごとに `{Resource}ListPagination` として定義し、`common/pagination/` のスカラーから必要なものをピックする。

## エラーレスポンスの設計方針

エラーレスポンスのボディは `error` オブジェクトでラップしない。HTTP ステータスコード（400・401・404 など）がすでにエラーであることを表しているため、さらに包む意味がなく、クライアントの処理も複雑になるため。

```json
// NG: error でラップする
{ "error": { "errorCode": "4000", "message": "..." } }

// OK: フラットに返す
{ "errorCode": "4000", "message": "..." }
```

## エラーレスポンスの構造

```json
{
  "errorCode": "4000",
  "message": "BadRequestException",
  "meta": { "respondedAt": "2025-01-01T12:00:00Z" }
}
```

`BadRequestException` のみ `details` を持つ（オプショナル）。

```json
{
  "errorCode": "4000",
  "message": "BadRequestException",
  "meta": { "respondedAt": "2025-01-01T12:00:00Z" },
  "details": [
    { "field": "email", "message": "メールアドレスの形式が不正です" }
  ]
}
```

500系はレスポンスボディを返さない（HTTP ステータスコードのみ）。

## エラーコード体系

- 先頭3桁: HTTP ステータスコード
- 以降: インクリメント（サービス・ドメイン固有エラーの連番）

```
4000 → 400系の汎用エラー
4001 → 400系の固有エラー1番目
4040 → 404系の汎用エラー
4041 → 404系の固有エラー1番目
```

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
```

### `kind: project`

TypeSpec 1.13.0 で追加されたフィールド。このディレクトリがプロジェクトの境界であることを宣言する。

設定することで以下の効果がある：

- **IDE 言語サーバーの精度向上**: `.tsp` ファイルを開いたとき、どのプロジェクトに属するかを正確に判定できるようになる
- **`--config` 使用時の自動継承**: `--config` で別の設定ファイルを指定した場合に `entrypoint` や `features` の設定を自動で引き継ぐ

### `entrypoint`

プロジェクトのエントリーポイントとなる `.tsp` ファイルを指定する。省略時のデフォルトは `main.tsp`。
このリポジトリでは常に `main.tsp` を使用するため、明示的に記載する。

## サービスの追加方法

1. `src/{service-name}/` フォルダを作成
2. `tspconfig.yaml` を作成（上記「tspconfig.yaml の構成ルール」を参照）
3. `main.tsp` を作成してルーティングを定義
4. `package.json` に `"build:{service-name}": "tsp compile src/{service-name}"` を追加
