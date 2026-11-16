@summary("ErrorTitle")
@doc("エラーの表題。何が起きたかを1行で表す、ログ向けの文。code ごとに同じ文になる。分岐や画面表示には使わない")
@example("リクエスト内容が不正です")
scalar ErrorTitle extends string;
