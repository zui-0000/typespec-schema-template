@summary("AddressLine1")
@doc("住所: 市区町村・番地 (最大100文字)")
@example("千代田区千代田1-1")
@minLength(1)
@maxLength(100)
scalar AddressLine1 extends string;
