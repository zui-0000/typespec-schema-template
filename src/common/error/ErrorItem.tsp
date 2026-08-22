@summary("ErrorItem")
@doc("エラーの内訳。どのフィールドがなぜ不正かを示す")
model ErrorItem {
  field: string;
  message: string;
}
