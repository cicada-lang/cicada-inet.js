import { Definition } from "../definition"
import { Module } from "../module"
import { Stmt } from "../stmt"

export class DefineRuleStmt extends Stmt {
  constructor(public name: string) {
    super()
  }

  async execute(mod: Module): Promise<void> {
    //
  }
}
