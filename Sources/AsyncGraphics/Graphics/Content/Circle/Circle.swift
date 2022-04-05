//
//  Created by Anton Heestand on 2022-04-03.
//

import CoreGraphics
import CoreGraphicsExtensions
import PixelColor

public extension Graphic {
    
    struct CircleUniforms {
        let radius: Float
        let position: PointUniform
        let edgeRadius: Float
        let foregroundColor: ColorUniform
        let edgeColor: ColorUniform
        let backgroundColor: ColorUniform
        let premultiply: Bool
        let resolution: SizeUniform
        let aspectRatio: Float
    }

    static func circle(color: PixelColor = .white,
                       backgroundColor: PixelColor = .black,
                       size: CGSize,
                       frame: CGRect) async throws -> Graphic {
        
        let resolution: CGSize = size.resolution
        
        let radius: CGFloat = min(frame.width, frame.height) / 2
        let relativeRadius: CGFloat = radius / size.height
        
        let position: CGPoint = frame.center
        let relativePosition: CGPoint = (position - size / 2) / size.height
        #warning("Flip Y")
        
        let edgeRadius: CGFloat = 0.0
        let edgeColor: PixelColor = .clear

        let premultiply: Bool = true
        
        let texture = try await Renderer.render(
            shaderName: "circle",
            uniforms: CircleUniforms(
                radius: Float(relativeRadius),
                position: relativePosition.uniform,
                edgeRadius: Float(edgeRadius),
                foregroundColor: color.uniform,
                edgeColor: edgeColor.uniform,
                backgroundColor: backgroundColor.uniform,
                premultiply: premultiply,
                resolution: resolution.uniform,
                aspectRatio: Float(resolution.aspectRatio)
            ),
            resolution: resolution,
            bits: ._8
        )
        
        return Graphic(texture: texture, bits: ._8, colorSpace: .sRGB)
    }
}
