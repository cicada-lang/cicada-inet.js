import { Net } from "./Net"
import { netConnectPorts } from "./netConnectPorts"
import { netRemoveEdge } from "./netRemoveEdge"
import { netRemoveNode } from "./netRemoveNode"

export function netCleanUpWires(net: Net): void {
  for (const wire of net.wires) {
    if (wire.start.connection && wire.end.connection) {
      netRemoveEdge(net, wire.start.connection.edge)
      netRemoveEdge(net, wire.end.connection.edge)

      netRemoveNode(net, wire.start.node)
      netRemoveNode(net, wire.end.node)

      netConnectPorts(net, wire.start.connection.port, wire.end.connection.port)
    }
  }

  net.wires = []
}
