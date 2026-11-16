# TypeSpec Schema Template

TypeSpec を使用した API スキーマ定義のテンプレートリポジトリ。
バックエンドサービスごとに OpenAPI (YAML) を出力し、API クライアント・型定義生成に使用する。

## 使い方

GitHub の「Use this template」から新しいリポジトリを作成し、以下でセットアップする。

```bash
mise install
pnpm install
pnpm build
```

サンプルとして `hoge-backend`（users）と `foo-backend`（products）の 2 サービスを置いている。
自分のサービスに置き換えるときは [サービスの追加方法](.claude/docs/implementation-conventions.md#サービスの追加方法) を参照。

## ドキュメント

- [開発環境・コマンド](.claude/docs/setup.md)
- [フォルダ構成](.claude/docs/folder-structure.md)
- [実装規約](.claude/docs/implementation-conventions.md)
- [コミット規約](.claude/docs/commit-conventions.md)
