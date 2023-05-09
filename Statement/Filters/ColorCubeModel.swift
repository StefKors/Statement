//
//  ColorCubeModel.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

enum LutImage: String, CaseIterable {
    case lut1 = "lut-1"
    case lut2 = "lut-2"
    case lut3 = "lut-3"
}

class ColorCubeModel: BaseFilterModel, ObservableObject {
    @Published var selectedImage: LutImage = .lut1

    let type: FilterType = .colorCube

    override func applyFilter(_ inputImage: CIImage) -> CIImage? {
        let currentFilter = CIFilter.colorCube()
        guard let data = self.colorCubeFilterFromLUT(imageName: selectedImage.rawValue) else {
            fatalError("need that data \(selectedImage.rawValue)")
        }
        currentFilter.cubeData = data
        currentFilter.cubeDimension = Float(64)
        currentFilter.inputImage = inputImage
        currentFilter.extrapolate = true
        return currentFilter.outputImage
    }

    // based on: https://stackoverflow.com/questions/55029167/apply-lut-lookup-table-on-image-swift-xcode
    fileprivate func colorCubeFilterFromLUT(imageName : String) -> Data? {

        let size = 64

        let lutImage    = NSImage(named: imageName)
        guard let image = lutImage else { return nil }

        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        guard let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return nil }

        let lutWidth    = imageRef.width
        let lutHeight   = imageRef.height
        let rowCount    = lutHeight / size
        let columnCount = lutWidth / size

        if ((lutWidth % size != 0) || (lutHeight % size != 0) || (rowCount * columnCount != size)) {
            NSLog("Invalid colorLUT %@", imageName);
            return nil
        }

        let bitmap  = self.getBytesFromImage(image: NSImage(named: imageName))!
        let floatSize = MemoryLayout<Float>.size

        let cubeData = UnsafeMutablePointer<Float>.allocate(capacity: size * size * size * 4 * floatSize)
        var z = 0
        var bitmapOffset = 0

        for _ in 0 ..< rowCount {
            for y in 0 ..< size {
                let tmp = z
                for _ in 0 ..< columnCount {
                    for x in 0 ..< size {

                        let alpha   = Float(bitmap[bitmapOffset]) / 255.0
                        let red     = Float(bitmap[bitmapOffset+1]) / 255.0
                        let green   = Float(bitmap[bitmapOffset+2]) / 255.0
                        let blue    = Float(bitmap[bitmapOffset+3]) / 255.0

                        let dataOffset = (z * size * size + y * size + x) * 4

                        cubeData[dataOffset + 3] = alpha
                        cubeData[dataOffset + 2] = red
                        cubeData[dataOffset + 1] = green
                        cubeData[dataOffset + 0] = blue
                        bitmapOffset += 4
                    }
                    z += 1
                }
                z = tmp
            }
            z += columnCount
        }

        let colorCubeData = NSData(bytesNoCopy: cubeData, length: size * size * size * 4 * floatSize, freeWhenDone: true)

        return colorCubeData as Data
    }

    fileprivate func getBytesFromImage(image:NSImage?) -> [UInt8]? {
        var pixelValues: [UInt8]?
        guard let image = image else { return nil }

        var imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        guard let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return nil }
        let width = Int(imageRef.width)
        let height = Int(imageRef.height)
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        let totalBytes = height * bytesPerRow

        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var intensities = [UInt8](repeating: 0, count: totalBytes)

        let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))

        pixelValues = intensities
        return pixelValues!
    }

}
