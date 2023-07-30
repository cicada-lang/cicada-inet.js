import { Edge } from "./Edge"
import { Net } from "./Net"
import { removeEdge } from "./removeEdge"

export function disconnect(net: Net, edge: Edge): void {
  removeEdge(net, edge)

  // Be careful about memory leak.
  delete edge.start.connection
  delete edge.end.connection
}
