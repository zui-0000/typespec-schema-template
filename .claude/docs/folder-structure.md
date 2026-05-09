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
│   ├── meta/                  # レスポンスメタデータ型
│   │   ├── CommonResponseMeta.tsp
│   │   └── RespondedAt.tsp
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
│   └── response/              # 共通レスポンスラッパー型
│       ├── ErrorResponses.tsp
│       └── SuccessResponses.tsp
└── {service-name}/            # サービスごとのスキーマ
    ├── main.tsp               # エントリーポイント・ルーティング定義
    ├── tspconfig.yaml         # ビルド設定
    └── {resource}/            # リソースごとのフォルダ
        ├── model/             # リソース固有のスカラー型
        ├── {Resource}CreateRequest.tsp
        ├── {Resource}CreateResponse.tsp
        └── ...
```
