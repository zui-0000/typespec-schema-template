import "./ErrorTitle.tsp";

@summary("ResourceNotFoundError")
@doc("リソースが存在しない（汎用）")
@error
@example(#{ code: "4040", title: "指定されたリソースは存在しません" })
model ResourceNotFoundError {
  code: "4040";
  title: ErrorTitle;
}
