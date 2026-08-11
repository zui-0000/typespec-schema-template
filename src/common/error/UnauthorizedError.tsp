import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";

@summary("UnauthorizedError")
@doc("認証情報が不正")
@error
@example(#{ errorCode: "4010", message: "UnauthorizedError" })
model UnauthorizedError {
  errorCode: ErrorCode;
  message: ErrorMessage;
}
