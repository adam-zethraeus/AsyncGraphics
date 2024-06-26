import SwiftUI
import CoreGraphics
import PixelColor

extension CodableGraphic.Content.Shape {
    
    @GraphicMacro
    public final class Star: ShapeContentGraphicProtocol {
        
        public var count: GraphicMetadata<Int> = .init(value: .fixed(5),
                                                       minimum: .fixed(3),
                                                       maximum: .fixed(12),
                                                       docs: "Count of outer points.")

        public var position: GraphicMetadata<CGPoint> = .init(options: .spatial)
        
        public var rotation: GraphicMetadata<Angle> = .init()

        public var innerRadius: GraphicMetadata<CGFloat> = .init(value: .resolutionMinimum(fraction: 0.25),
                                                                 maximum: .resolutionMaximum(fraction: 0.5),
                                                                 options: .spatial,
                                                                 docs: "Radius of inner points.")
        
        public var outerRadius: GraphicMetadata<CGFloat> = .init(value: .resolutionMinimum(fraction: 0.5),
                                                                 maximum: .resolutionMaximum(fraction: 0.5),
                                                                 options: .spatial,
                                                                 docs: "Radius of outer points.")
        
        public var cornerRadius: GraphicMetadata<Double> = .init(value: .fixed(0.0),
                                                                 maximum: .resolutionMinimum(fraction: 0.5),
                                                                 options: .spatial)
        
        public var foregroundColor: GraphicMetadata<PixelColor> = .init(value: .fixed(.white))
        public var backgroundColor: GraphicMetadata<PixelColor> = .init(value: .fixed(.clear))
        
        public func render(
            at resolution: CGSize,
            options: Graphic.ContentOptions = []
        ) async throws -> Graphic {
            
            try await .star(
                count: count.value.eval(at: resolution),
                innerRadius: innerRadius.value.eval(at: resolution),
                outerRadius: outerRadius.value.eval(at: resolution),
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
            case regular
            case rounded
        }

        public func edit(variant: Variant) {
            innerRadius.value = .resolutionMinimum(fraction: 1.0 / 8.0)
            outerRadius.value = .resolutionMinimum(fraction: 1.0 / 4.0)
            switch variant {
            case .regular:
                break
            case .rounded:
                cornerRadius.value = .resolutionMinimum(fraction: 1.0 / 32)
            }
        }
    }
}
