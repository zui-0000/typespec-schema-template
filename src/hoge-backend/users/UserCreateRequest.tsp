import "@typespec/rest";
import "../../common/model/index.tsp";
import "./model/index.tsp";

@summary("UserCreateRequest")
model UserCreateRequest {
  firstName: FirstName;
  lastName: LastName;
  mailAddress: MailAddress;
  phoneNumber: PhoneNumber;
  gender: Gender;
  postalCode: PostalCode;
  prefecture: Prefecture;
  addressLine1: AddressLine1;
  addressLine2: AddressLine2;
}
