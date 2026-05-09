@summary("PostalCode")
@doc("郵便番号 (ハイフンなし7桁)")
@example("1000001")
@minLength(7)
@maxLength(7)
@pattern("^[0-9]{7}$")
scalar PostalCode extends string;
