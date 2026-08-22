import "./ErrorTitle.tsp";

@summary("ForbiddenError")
@doc("操作する権限が無い（汎用）")
@error
@example(#{
  status: 403,
  code: "4030",
  title: "この操作を行う権限がありません",
})
model ForbiddenError {
  status: 403;
  code: "4030";
  title: ErrorTitle;
}
