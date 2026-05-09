import "@typespec/rest";
import "../../common/model/index.tsp";
import "./UserGetResult.tsp";

@summary("UserGetResponse")
model UserGetResponse {
  result: UserGetResult;
  meta: CommonResponseMeta;
}
