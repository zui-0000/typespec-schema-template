import "./ListUsersPagination.tsp";
import "./ListUsersResult.tsp";

@summary("ListUsersResponse")
model ListUsersResponse {
  users: ListUsersResult[];
  pagination: ListUsersPagination;
}
