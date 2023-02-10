
import CoreGraphics

public struct AGForEach: AGGraph {
    
    var graphs: [any AGGraph]
    
    public init(_ range: Range<Int>, graph: (Int) -> any AGGraph) {
        self.graphs = range.map { graph($0) }
    }
    
    public init(_ range: ClosedRange<Int>, graph: (Int) -> any AGGraph) {
        self.graphs = range.map { graph($0) }
    }
    
    
    public func contentResolution(in containerResolution: CGSize) -> AGResolution {
        .auto
    }
    
    public func render(with details: AGRenderDetails) async throws -> Graphic {
        try await .color(.clear, resolution: details.resolution)
    }
}

extension AGForEach: Equatable {
    
    public static func == (lhs: AGForEach, rhs: AGForEach) -> Bool {
        guard lhs.graphs.count == rhs.graphs.count else { return false }
        for (lhsGraph, rhsGraph) in zip(lhs.graphs, rhs.graphs) {
            guard lhsGraph.isEqual(to: rhsGraph) else { return false }
        }
        return true
    }
}

extension AGForEach: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        for graph in graphs {
            hasher.combine(graph)
        }
    }
}