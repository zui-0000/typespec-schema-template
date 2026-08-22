// エラーコードは `<HTTP ステータス><連番>` の4桁で、**各エラーがリテラルで持つ**。
//
// 以前は `scalar ErrorCode extends string` を共有し、実際の値は `@example` に書いていた。
// だが example は制約ではないため、同じステータスの2つ（例: 4010 と 4011）を
// クライアントが型で区別できなかった。エラーを分けた目的そのものが契約に出ていない状態。
// リテラルにすると生成物が `zod.literal("4011")` になり、判別可能な直和になる。
//
// `status` も同じくリテラルで持つ。理由は response/ErrorResponses.tsp を参照。

import "./BadRequestError.tsp";
import "./ConflictError.tsp";
import "./ErrorItem.tsp";
import "./ErrorTitle.tsp";
import "./ForbiddenError.tsp";
import "./InternalServerError.tsp";
import "./ResourceNotFoundError.tsp";
import "./UnauthorizedError.tsp";
