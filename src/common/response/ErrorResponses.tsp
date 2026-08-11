import "@typespec/http";
import "../error/index.tsp";

using TypeSpec.Http;

/** リクエスト内容が不正 */
model BadRequestErrorResponse {
  @statusCode statusCode: 400;
  @body error: BadRequestError;
}

/** 認証情報が不正 */
model UnauthorizedErrorResponse {
  @statusCode statusCode: 401;
  @body error: UnauthorizedError;
}

/** リソースが見つからない */
model NotFoundErrorResponse {
  @statusCode statusCode: 404;
  @body error: ResourceNotFoundError;
}

/** サーバーエラー */
model InternalServerErrorResponse {
  @statusCode statusCode: 500;
}
