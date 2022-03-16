import * as Defs from "../definitions"
import { Module } from "../module"
import { Stmt, StmtMeta } from "../stmt"
import { buildTypes } from "../types"

export class DefineConsStmt extends Stmt {
  constructor(
    public name: string,
    public input: Array<string>,
    public output: Array<string>,
    public meta: StmtMeta
  ) {
    super()
  }

  async execute(mod: Module): Promise<void> {
    mod.define(
      this.name,
      new Defs.NodeDefinition(
        mod,
        this.name,
        buildTypes(this.input),
        buildTypes([...this.output, "*"])
      )
    )
  }
}
