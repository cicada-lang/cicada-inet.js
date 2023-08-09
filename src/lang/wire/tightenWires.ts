import { connect } from "../connect/connect"
import { disconnect } from "../connect/disconnect"
import { Env } from "../env"

export function tightenWires(env: Env): void {
  for (const wire of env.wires) {
    if (wire.first.connection && wire.second.connection) {
      const first = wire.first.connection.port
      const second = wire.second.connection.port

      disconnect(env, wire.first.connection.edge)
      disconnect(env, wire.second.connection.edge)

      connect(env, first, second)
    }
  }

  env.wires = []
}
