@summary("PhoneNumber")
@doc("電話番号 (11桁固定、ハイフンなし)")
@example("09012345678")
@minLength(11)
@maxLength(11)
@pattern("^[0-9]{11}$")
scalar PhoneNumber extends string;
