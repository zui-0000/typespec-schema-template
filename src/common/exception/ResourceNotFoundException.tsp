import "@typespec/rest";
import "../model/index.tsp";

@summary("ResourceNotFoundException")
@doc("リソースが存在しない")
@error
@example(#{
  errorCode: "4040",
  message: "ResourceNotFoundException",
  meta: #{ respondedAt: "2025-01-01T12:00:00Z" },
})
model ResourceNotFoundException {
  errorCode: ErrorCode;
  message: ErrorMessage;
  meta: CommonResponseMeta;
}
