import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";
import "./ErrorDetail.tsp";

@summary("BadRequestException")
@doc("リクエスト内容が不正")
@error
@example(#{
  errorCode: "4000",
  message: "BadRequestException",
  details: #[#{ field: "email", message: "メールアドレスの形式が不正です" }],
})
model BadRequestException {
  errorCode: ErrorCode;
  message: ErrorMessage;
  details?: ErrorDetail[];
}
