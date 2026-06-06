import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./products/index.tsp";
import "../common/index.tsp";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

@service(#{ title: "Foo Backend API" })
namespace FooBackendApi {
  @tag("Products")
  @route("/products")
  namespace Products {
    /** 全商品を取得する */
    @get
    @operationId("listProducts")
    op list(@query currentPage: CurrentPage, @query perPage: PerPage):
      | SuccessOkResponse<ProductListResponse>
      | InternalServerErrorResponse;

    /** IDを指定して商品を取得する */
    @get
    @route("/{id}")
    @operationId("getProduct")
    op get(@path id: ProductId):
      | SuccessOkResponse<ProductGetResponse>
      | NotFoundErrorResponse
      | InternalServerErrorResponse;

    /** 商品を新規作成する */
    @post
    @operationId("createProduct")
    op create(@body body: ProductCreateRequest):
      | SuccessCreatedResponse<ProductCreateResponse>
      | BadRequestErrorResponse
      | InternalServerErrorResponse;
  }
}
