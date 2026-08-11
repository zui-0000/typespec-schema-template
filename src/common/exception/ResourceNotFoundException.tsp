import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";

@summary("ResourceNotFoundException")
@doc("リソースが存在しない")
@error
@example(#{ errorCode: "4040", message: "ResourceNotFoundException" })
model ResourceNotFoundException {
  errorCode: ErrorCode;
  message: ErrorMessage;
}
