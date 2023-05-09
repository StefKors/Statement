//
//  AdjustableColorCubeModel.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins


class AdjustableColorCubeModel: BaseFilterModel, ObservableObject {
    @Published var brightnessAdjustment: Float = 0.9
    @Published var saturationAdjustment: Float = 0
    @Published var destCenterHueAngle: Float = 0.57

    override func applyFilter(_ inputImage: CIImage) -> CIImage? {
        let currentFilter = CIFilter.colorCube()
        currentFilter.cubeData = createCubeData()
        currentFilter.cubeDimension = Float(64)
        currentFilter.inputImage = inputImage
        currentFilter.extrapolate = true
        return currentFilter.outputImage
    }

    /// https://github.com/DerLobi/XcoatOfPaint/blob/ccebea8d243317a63e7581e96a29937186e3aaa3/XcoatOfPaint/ImageEditor.swift#L104
    private func createCubeData() -> Data {
        let defaultHue: Float = 205
        let maximumMonochromeSaturationThreshold: Float = 0.2
        let maximumMonochromeBrightnessThreshold: Float = 0.2

        let centerHueAngle: Float = defaultHue/360.0

        let hueAdjustment = centerHueAngle - destCenterHueAngle
        let size = 64
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)
        var rgb: [Float] = [0, 0, 0]
        var hsv: (h: Float, s: Float, v: Float)
        var newRGB: (r: Float, g: Float, b: Float)
        var offset = 0
        for z in 0 ..< size {
            rgb[2] = Float(z) / Float(size) // blue value
            for y in 0 ..< size {
                rgb[1] = Float(y) / Float(size) // green value
                for x in 0 ..< size {
                    rgb[0] = Float(x) / Float(size) // red value
                    hsv = RGBtoHSV(rgb[0], g: rgb[1], b: rgb[2])

                    // special consigeration for monochrome elements
                    // like the hammer or the "A" glyph
                    let isConsideredMonochrome =
                    hsv.s < maximumMonochromeSaturationThreshold
                    || hsv.v < maximumMonochromeBrightnessThreshold

                    if isConsideredMonochrome {
                        if saturationAdjustment < 0 {
                            hsv.s += saturationAdjustment
                        }

                        newRGB = HSVtoRGB(hsv.h, s: hsv.s, v: hsv.v)
                    } else {
                        hsv.s += saturationAdjustment
                        hsv.v += (brightnessAdjustment * hsv.v)
                        hsv.h -= hueAdjustment
                        newRGB = HSVtoRGB(hsv.h, s: hsv.s, v: hsv.v)
                    }
                    cubeData[offset] = newRGB.r
                    cubeData[offset+1] = newRGB.g
                    cubeData[offset+2] = newRGB.b
                    cubeData[offset+3] = 1.0
                    offset += 4
                }
            }
        }
        // print(cubeData)
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as Data
        return data
    }
}
