import "@typespec/rest";
import "../model/index.tsp";

@summary("UnauthorizedException")
@doc("認証情報が不正")
@error
@example(#{
  errorCode: "4010",
  message: "UnauthorizedException",
  meta: #{ respondedAt: "2025-01-01T12:00:00Z" },
})
model UnauthorizedException {
  errorCode: ErrorCode;
  message: ErrorMessage;
  meta: CommonResponseMeta;
}
