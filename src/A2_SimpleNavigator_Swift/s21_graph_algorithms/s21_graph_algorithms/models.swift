
import Foundation

public struct VertexDistance: Equatable, Hashable {
    let vertex: Int
    let distance: Int
}

public func ==(lhs: VertexDistance, rhs: VertexDistance) -> Bool {
    return lhs.vertex == rhs.vertex && lhs.distance == rhs.distance
}

public struct TsmResult {
    public var vertices: [Int] // массив с искомым маршрутом (с порядком обхода вершин).
    public var distance: Double // длина этого маршрута
}
