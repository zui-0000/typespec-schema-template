@summary("LastName")
@doc("ユーザー姓 (最大25文字)")
@example("山田")
@minLength(1)
@maxLength(25)
scalar LastName extends string;
