import "./ErrorCode.tsp";
import "./ErrorMessage.tsp";
import "./ErrorDetail.tsp";

@summary("BadRequestError")
@doc("リクエスト内容が不正")
@error
@example(#{
  errorCode: "4000",
  message: "BadRequestError",
  details: #[#{ field: "email", message: "メールアドレスの形式が不正です" }],
})
model BadRequestError {
  errorCode: ErrorCode;
  message: ErrorMessage;
  details?: ErrorDetail[];
}
