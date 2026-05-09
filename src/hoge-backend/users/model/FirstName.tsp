@summary("FirstName")
@doc("ユーザー名 (最大25文字)")
@example("太郎")
@minLength(1)
@maxLength(25)
scalar FirstName extends string;
