import "@typespec/rest";
import "../../common/model/index.tsp";

@summary("UserCreateResponse")
model UserCreateResponse {
  meta: CommonResponseMeta;
}
