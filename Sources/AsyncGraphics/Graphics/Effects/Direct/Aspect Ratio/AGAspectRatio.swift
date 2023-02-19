import CoreGraphics

extension AGGraph {
    
    public func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: AGContentMode) -> any AGGraph {
        AGAspectRatio(graph: self, aspectRatio: aspectRatio, contentMode: contentMode)
    }
    
    public func aspectRatio(_ aspectRatio: CGSize, contentMode: AGContentMode) -> any AGGraph {
        AGAspectRatio(graph: self, aspectRatio: aspectRatio.width / aspectRatio.height, contentMode: contentMode)
    }
}

public struct AGAspectRatio: AGParentGraph {
   
    public var children: [any AGGraph] { [graph] }
    
    let graph: any AGGraph
    
    let aspectRatio: CGFloat?
    let contentMode: AGContentMode
    
    public func resolution(for specification: AGSpecification) -> AGDynamicResolution {
        let placement: Placement = {
            switch contentMode {
            case .fit:
                return .fit
            case .fill:
                return .fill
            }
        }()
        if let aspectRatio {
            return .fixed(CGSize(width: aspectRatio, height: 1.0)
                .place(in: specification.resolution, placement: placement))
        }
        let dynamicResolution: AGDynamicResolution = graph.resolution(for: specification)
        if let size: CGSize = dynamicResolution.size {
            return .fixed(size.place(in: specification.resolution, placement: placement))
        }
        return dynamicResolution
    }
    
    public func render(with details: AGDetails) async throws -> Graphic {
        let resolution: CGSize = fallbackResolution(for: details.specification)
        let graphic: Graphic = try await graph.render(with: details.with(resolution: resolution))
        if aspectRatio != nil {
            let backgroundGraphic: Graphic = try await .color(.clear, resolution: resolution)
            return try await backgroundGraphic.blended(with: graphic,
                                                       blendingMode: .over,
                                                       placement: .center)
        } else {
            return graphic
        }
    }
}

extension AGAspectRatio: Equatable {

    public static func == (lhs: AGAspectRatio, rhs: AGAspectRatio) -> Bool {
        guard lhs.aspectRatio == rhs.aspectRatio else { return false }
        guard lhs.contentMode == rhs.contentMode else { return false }
        guard lhs.graph.isEqual(to: rhs.graph) else { return false }
        return true
    }
}

extension AGAspectRatio: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(aspectRatio)
        hasher.combine(contentMode)
        hasher.combine(graph)
    }
}
