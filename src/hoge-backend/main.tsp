import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./users/index.tsp";
import "../common/index.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

@service(#{ title: "Hoge Backend API" })
namespace HogeBackendApi {
  @tag("Users")
  @route("/users")
  namespace Users {
    /** 全ユーザーを取得する */
    @get
    @operationId("listUsers")
    op list(@query currentPage: CurrentPage, @query perPage: PerPage):
      | SuccessOkResponse<UserListResponse>
      | InternalServerErrorResponse;

    /** IDを指定してユーザーを取得する */
    @get
    @route("/{id}")
    @operationId("getUser")
    op get(@path id: Uuid):
      | SuccessOkResponse<UserGetResponse>
      | NotFoundErrorResponse
      | InternalServerErrorResponse;

    /** ユーザーを新規作成する */
    @post
    @operationId("createUser")
    op create(@body body: UserCreateRequest):
      | SuccessCreatedResponse<UserCreateResponse>
      | BadRequestErrorResponse
      | InternalServerErrorResponse;

    /** ユーザーを更新する */
    @put
    @route("/{id}")
    @operationId("updateUser")
    op update(@path id: Uuid, @body body: UserUpdateRequest):
      | SuccessNoContentResponse
      | BadRequestErrorResponse
      | NotFoundErrorResponse
      | InternalServerErrorResponse;

    /** ユーザーを削除する */
    @delete
    @route("/{id}")
    @operationId("deleteUser")
    op delete(@path id: Uuid):
      | SuccessNoContentResponse
      | NotFoundErrorResponse
      | InternalServerErrorResponse;
  }
}
