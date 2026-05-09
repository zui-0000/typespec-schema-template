import "@typespec/rest";
import "../../common/model/index.tsp";

@summary("UserUpdateResponse")
model UserUpdateResponse {
  meta: CommonResponseMeta;
}
