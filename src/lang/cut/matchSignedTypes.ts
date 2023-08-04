import { Ctx, Sign, SignedType } from "../ctx"
import { matchTypes } from "./matchTypes"

export function matchSignedTypes(
  ctx: Ctx,
  left: SignedType,
  right: SignedType,
): void {
  if (left.sign === -1 && right.sign === 1) {
    matchTypes(ctx, left.t, right.t)
    return
  }

  if (left.sign === 1 && right.sign === -1) {
    matchTypes(ctx, left.t, right.t)
    return
  }

  if (left.sign === 0 && right.sign === 0) {
    matchTypes(ctx, left.t, right.t)
    return
  }

  if (left.sign === 0) {
    matchTypes(ctx, left.t, right.t)
    setNeutralSignedType(ctx, left, right)
    return
  }

  if (right.sign === 0) {
    matchTypes(ctx, left.t, right.t)
    setNeutralSignedType(ctx, right, left)
    return
  }

  console.error({ left, right })

  throw new Error(`[matchSignedTypes] I expect the sign to be opposite`)
}

function setNeutralSignedType(
  ctx: Ctx,
  neutralSignedType: SignedType,
  signedType: SignedType,
): void {
  if (neutralSignedType.id === undefined) {
    throw new Error(
      `[setNeutralSignedType] I expect neutralSignedType to have id`,
    )
  }

  const found = ctx.neutralSignedTypes.get(neutralSignedType.id)
  if (found === undefined) {
    throw new Error(
      `[setNeutralSignedType] I can not find neutralSignedType for id: ${neutralSignedType.id}`,
    )
  }

  neutralSignedType.sign = -signedType.sign as Sign
  found.sign = signedType.sign

  ctx.neutralSignedTypes.delete(neutralSignedType.id)

  return
}
