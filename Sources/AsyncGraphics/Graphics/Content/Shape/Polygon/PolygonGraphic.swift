import SwiftUI
import CoreGraphics
import PixelColor

extension CodableGraphic.Content.Shape {
    
    @GraphicMacro
    public final class Polygon: ShapeContentGraphicProtocol {
        
        public var count: GraphicMetadata<Int> = .init(value: .fixed(3), 
                                                       minimum: .fixed(3),
                                                       maximum: .fixed(12),
                                                       docs: "Corner count.")

        public var position: GraphicMetadata<CGPoint> = .init(options: .spatial)
        
        public var rotation: GraphicMetadata<Angle> = .init()

        public var radius: GraphicMetadata<CGFloat> = .init(value: .resolutionMinimum(fraction: 0.5),
                                                            maximum: .resolutionMaximum(fraction: 0.5),
                                                            options: .spatial)
        
        public var cornerRadius: GraphicMetadata<Double> = .init(value: .fixed(0.0),
                                                                 maximum: .resolutionMinimum(fraction: 0.5),
                                                                 options: .spatial)
        
        public var foregroundColor: GraphicMetadata<PixelColor> = .init(value: .fixed(.white))
        public var backgroundColor: GraphicMetadata<PixelColor> = .init(value: .fixed(.clear))
        
        public func render(
            at resolution: CGSize,
            options: Graphic.ContentOptions = []
        ) async throws -> Graphic {
            
            try await .polygon(
                count: count.value.eval(at: resolution),
                radius: radius.value.eval(at: resolution),
                position: position.value.eval(at: resolution),
                rotation: rotation.value.eval(at: resolution),
                cornerRadius: cornerRadius.value.eval(at: resolution),
                color: foregroundColor.value.eval(at: resolution),
                backgroundColor: backgroundColor.value.eval(at: resolution),
                resolution: resolution,
                options: options)
        }
        
        @VariantMacro
        public enum Variant: String, GraphicVariant {
            case triangle
            case diamond
            case pentagon
            case hexagon
        }

        public func edit(variant: Variant) {
            switch variant {
            case .triangle:
                count.value = .fixed(3)
            case .diamond:
                count.value = .fixed(4)
            case .pentagon:
                count.value = .fixed(5)
            case .hexagon:
                count.value = .fixed(6)
            }
        }
    }
}
