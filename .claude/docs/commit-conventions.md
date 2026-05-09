# コミット規約

lefthook により pre-commit・commit-msg フックが自動実行される。

コミットメッセージは以下の prefix を使用する（`.commitlintrc.yaml` 参照）。

| prefix | 用途 |
|--------|------|
| `feat` | 新しいスキーマ・エンドポイントの追加 |
| `fix` | スキーマ定義の誤り修正 |
| `docs` | コメントや README の更新 |
| `refactor` | 構造の整理（定義内容は変えない） |
| `chore` | 依存更新・ツール設定変更 |
| `ci` | CI 設定の変更 |
| `build` | TypeSpec のビルド設定変更 |
| `revert` | 以前のコミットの取り消し |
