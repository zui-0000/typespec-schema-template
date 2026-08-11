import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";

@summary("UnauthorizedException")
@doc("認証情報が不正")
@error
@example(#{ errorCode: "4010", message: "UnauthorizedException" })
model UnauthorizedException {
  errorCode: ErrorCode;
  message: ErrorMessage;
}
