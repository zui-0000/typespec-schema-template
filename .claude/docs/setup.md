# 開発環境・コマンド

## 開発環境

mise でツールバージョンを管理している。以下を実行してセットアップする。

```bash
mise install
pnpm install
```

`pnpm install` 実行時に `lefthook install` も自動実行される。

## コマンド

| コマンド | 内容 |
|---------|------|
| `pnpm build` | フォーマット後、全サービスをビルド |
| `pnpm preview` | Swagger UI をローカル起動（http://localhost:8080） |
| `pnpm format` | スキーマをフォーマット |
| `pnpm check:updates` | 依存パッケージの更新確認 |

ビルド成果物は `dist/{service-name}-openapi.yaml` に出力される。

`pnpm preview` は Docker が必要。先に `pnpm build` でビルド済みの YAML を生成しておくこと。
Swagger UI 上のドロップダウンでサービスを切り替えて確認できる。
