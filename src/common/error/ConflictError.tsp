import "./ErrorTitle.tsp";

@summary("ConflictError")
@doc("リソースの現在の状態と衝突する（汎用）")
@error
@example(#{ code: "4090", title: "リソースの現在の状態と衝突します" })
model ConflictError {
  code: "4090";
  title: ErrorTitle;
}
