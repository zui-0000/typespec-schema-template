import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";

@summary("ResourceNotFoundError")
@doc("リソースが存在しない")
@error
@example(#{ errorCode: "4040", message: "ResourceNotFoundError" })
model ResourceNotFoundError {
  errorCode: ErrorCode;
  message: ErrorMessage;
}
