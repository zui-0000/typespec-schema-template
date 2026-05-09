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
| `pnpm format-all` | スキーマ + package.json をフォーマット |
| `pnpm check:updates` | 依存パッケージの更新確認 |

ビルド成果物は `dist/{service-name}-openapi.yaml` に出力される。
