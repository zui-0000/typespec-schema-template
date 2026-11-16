# 開発環境・コマンド

## 開発環境

Node.js と pnpm の版は mise（`mise.toml`）で管理している。以下を実行してセットアップする。

```bash
mise install
pnpm install
```

`pnpm install` 実行時に `prepare` スクリプトで `lefthook install` も自動実行され、
Git フックが登録される（[コミット規約](commit-conventions.md) を参照）。

## コマンド

| コマンド | 内容 |
|---------|------|
| `pnpm build` | フォーマット後、全サービスをビルド |
| `pnpm preview` | Swagger UI をローカル起動（http://localhost:8080） |
| `pnpm format` | スキーマをフォーマット |
| `pnpm check:updates` | 依存パッケージの更新確認 |

ビルド成果物は `dist/{service-name}-openapi.yaml` に出力される。

`pnpm preview` は Docker が必要。`dist/` の YAML をそのまま読むので、スキーマを変えたら先に `pnpm build` しておく。
Swagger UI 上のドロップダウンでサービスを切り替えて確認できる。

## 依存パッケージの管理

`pnpm-workspace.yaml` で以下を設定している。

- **版の固定**: `pnpm add` は `^` を付けずに版を固定して書く（`savePrefix: ""`）。版が動くのは上げたときだけになる
- **公開直後の版を入れない**: 公開から 1 日たっていない版は入れない（`minimumReleaseAge`）。
  上げようとして止まったら、1 日待ってから上げる
- **公開の証明が弱い版を入れない**: 以前の版より provenance などが弱い版は入れない（`trustPolicy: no-downgrade`）。
  例外にするときは `trustPolicyExclude` に版まで書き、上げるたびに確かめ直す

依存を上げるときは `pnpm check:updates` で確認し、`pnpm add -D <pkg>@<version>` で上げる。
