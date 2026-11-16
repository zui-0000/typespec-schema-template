import "./ErrorTitle.tsp";

@summary("UnauthorizedError")
@doc("認証情報が不正（汎用）")
@error
@example(#{ code: "4010", title: "認証情報が正しくありません" })
model UnauthorizedError {
  code: "4010";
  title: ErrorTitle;
}
