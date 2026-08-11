# フォルダ構成

```
src/
├── common/                    # 複数サービスで共有する共通型
│   ├── exception/             # エラーレスポンス型（エラーごとに定義）
│   │   ├── ErrorCode.tsp
│   │   ├── ErrorMessage.tsp
│   │   ├── ErrorDetail.tsp
│   │   ├── BadRequestException.tsp
│   │   ├── ResourceNotFoundException.tsp
│   │   └── UnauthorizedException.tsp
│   ├── model/                 # 汎用スカラー・型（ドメイン非依存）
│   │   ├── AccessToken.tsp
│   │   ├── Gender.tsp
│   │   ├── Uuid.tsp
│   │   └── ...
│   ├── pagination/            # ページネーション用スカラー
│   │   ├── CurrentPage.tsp
│   │   ├── PerPage.tsp
│   │   ├── TotalCount.tsp
│   │   └── TotalPages.tsp
│   └── response/              # ステータスコードとボディを束ねるレスポンス型
│       ├── ErrorResponses.tsp
│       └── SuccessResponses.tsp
└── {service-name}/            # サービスごとのスキーマ
    ├── main.tsp               # エントリーポイント・ルーティング定義
    ├── tspconfig.yaml         # ビルド設定
    └── {resource}/            # リソースごとのフォルダ
        ├── model/             # リソース固有のスカラー型
        ├── Create{Resource}Request.tsp
        ├── Create{Resource}Response.tsp
        ├── Get{Resource}Response.tsp
        ├── List{Resources}Response.tsp
        ├── List{Resources}Result.tsp
        ├── List{Resources}Pagination.tsp
        └── Update{Resource}Request.tsp
```

ファイル名は動詞が先頭に来る（`CreateUserRequest.tsp`）。
命名の詳細は [実装規約の命名規則](implementation-conventions.md#命名規則) を参照。
