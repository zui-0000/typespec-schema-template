import "./UserListPagination.tsp";
import "./UserListResult.tsp";

@summary("UserListResponse")
model UserListResponse {
  result: UserListResult[];
  meta: CommonResponseMeta;
  pagination: UserListPagination;
}
