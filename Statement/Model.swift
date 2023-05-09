//
//  Model.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//


import SwiftUI
import AppKit
import PhotosUI
import CoreTransferable
import Accelerate
import CoreGraphics

import CoreImage
import CoreImage.CIFilterBuiltins

@MainActor
class Model: ObservableObject {
    internal init() {
        if let data = imageStorage {
            guard let nsImage = NSImage(data: data) else {
                return
            }
            let image = Image(nsImage: nsImage)
            self.imageState = .success(EditorImage(image: image, data: data))
        }

        if let data = filterImageStorage {
            guard let nsImage = NSImage(data: data) else {
                return
            }
            let image = Image(nsImage: nsImage)
            self.filterImageState = .success(EditorImage(image: image, data: data))
        }
    }


    // MARK: - Image

    enum ImageState {
        case empty
        case loading(Progress)
        case success(EditorImage)
        case failure(Error)
    }

    enum TransferError: Error {
        case importFailed
    }

    struct EditorImage: Transferable {
        let image: Image
        let data: Data

        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return EditorImage(image: image, data: data)
            }
        }
    }

    @AppStorage("imageDataStorage") var imageStorage: Data?
    @AppStorage("filterImageDataStorage") var filterImageStorage: Data?

    @Published private(set) var imageState: ImageState = .empty
    @Published private(set) var filterImageState: ImageState = .empty


    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }

    @Published var editedImage: Image?

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: EditorImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let editorImage?):
                    self.imageState = .success(editorImage)
                    self.imageStorage = editorImage.data
                    self.filterImageState = .empty
                    self.filterImageStorage = nil
                    self.applyFilter(type: .ColorCube)

                    // Task {
                    //     do {
                    //         guard let outputImage = try await self.smallSample() else { return }
                    //
                    //         // guard let image = CIImage(data: editorImage.data) else {
                    //         //     print("failed make CiImage ❌")
                    //         //     return }
                    //         // guard let outputImage = try await self.createLutData(image: image) else {
                    //         //     print("failed createLutData ❌")
                    //         //     return }
                    //         let size = NSSize(width: outputImage.width, height: outputImage.height)
                    //         let nsImage = NSImage(cgImage: outputImage, size: size)
                    //         self.editedImage = Image(nsImage: nsImage)
                    //     } catch {
                    //         print("failed task ❌")
                    //     }
                    // }
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }

    enum ImageFilter: String, CaseIterable {
        case Sepia
        case ColorCube
    }

    func applyFilter(type: ImageFilter) {
        print("apply filter 👋")
        guard let imageStorage else {
            print("fail ❌ 1")
            return
        }

        guard let inputImage = CIImage(data: imageStorage) else {
            print("fail ❌ 3")
            return
        }

        let context = CIContext()


        guard let outputImage = filterOption(type: type, inputImage: inputImage) else {
            print("fail ❌ 4")
            return
        }

        // attempt to get a CGImage from our CIImage
        guard let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("fail ❌ 5")
            return
        }

        // convert that to a UIImage
        let size = inputImage.extent.size
        print("creating image with size \(size.debugDescription)")
        let nsImage = NSImage(cgImage: cgimg, size: size)
        guard let data = nsImage.tiffRepresentation else {
            // guard let data = outputImage.cgImage?.dataProvider?.data else {
            print("fail ❌ 6")
            return
        }
        // and convert that to a SwiftUI image
        let image = Image(nsImage: nsImage)
        let editorImage = EditorImage(image: image, data: data)
        self.filterImageState = .success(editorImage)
        self.filterImageStorage = data




        // if let imageStorage, let lutData = getLutData(), let ciInputImage = CIImage(data: imageStorage) {
        //     let params: [String : Any] = [ "cubeData" : lutData, "inputImage": ciInputImage ]
        //     // let filter = CIFilter(name: "CIColorCube", parameters: params)
        //     ciInputImage.applyingFilter("CIColorCube", parameters: params)
        //     if let data = ciInputImage.cgImage?.dataProvider?.data, let cgImage =  ciInputImage.cgImage {
        //         let image = Image(nsImage: NSImage(cgImage: cgImage, size: ciInputImage.extent.size))
        // let editorImage = EditorImage(image: image, data: data as Data)
        // self.filterImageState = .success(editorImage)
        // self.filterImageStorage = data as Data
        //     }
        // }
    }

    // from: https://www.hackingwithswift.com/books/ios-swiftui/integrating-core-image-with-swiftui
    func filterOption(type: ImageFilter, inputImage: CIImage) -> CIImage? {
        switch type {
        case .Sepia:
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = inputImage
            currentFilter.intensity = 1
            // return currentFilter.outputImage
            return nil
        case .ColorCube:
            let currentFilter = CIFilter.colorCube()
            // guard let data = getLutData() else { return nil }
            currentFilter.cubeData = createCubeData()
            currentFilter.cubeDimension = Float(64)
            currentFilter.inputImage = inputImage
            currentFilter.extrapolate = true
            return currentFilter.outputImage
        }


    }

    /// https://github.com/DerLobi/XcoatOfPaint/blob/ccebea8d243317a63e7581e96a29937186e3aaa3/XcoatOfPaint/ImageEditor.swift#L104
    func createCubeData() -> Data {
        var brightnessAdjustment: Float = 0.9
        var saturationAdjustment: Float = 0
        var destCenterHueAngle: Float = 0.57

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
        let b = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }
        let data = b as Data
        return data
    }

    func getLutData() -> Data? {
        let lutImage = NSImage(named: "lut-sample")
        // let lutImage = ImageRenderer(content: Image("lut-sample").frame(width: 600, height: 600))
        // guard let dimension = 64 else {
        //     print("failed ❌ finding height")
        //     return nil
        // }

        // get data from image
        guard let lutImageData = lutImage?.tiffRepresentation else {
            print("failed ❌ getting data")
            return nil
        }
        let lutImageDataPtr = CFDataGetBytePtr(lutImageData as CFData)!

        // convert to float and divide by 255
        let numElements =  8//Int((dimension * dimension * dimension * 4).rounded())
        let inDataFloat = UnsafeMutablePointer<Float>.allocate(capacity: numElements)
        vDSP_vfltu8(lutImageDataPtr, 1, inDataFloat, 1, vDSP_Length(numElements))
        var div: Float = 255.0
        vDSP_vsdiv(inDataFloat, 1, &div, inDataFloat, 1, vDSP_Length(numElements))

        // convert buffer pointer to data
        let lutData = NSData(bytesNoCopy: inDataFloat, length: numElements * MemoryLayout<Float>.size, freeWhenDone: true)

        // Create CIColorCube filter
        // let params: [String : Any] = [ "inputCubeData" : lutData ]
        // let filter = CIFilter(name: "CIColorCube", parameters: params)
        // filter.inputImage = inputImage
        // filter.cubeData = data
        // filter.cubeDimension = Float(dimension)

        return lutData.base64EncodedData()
    }

    fileprivate func createTableData(_ lookupTableElementCount: Int, _ entriesPerChannel: UInt8) -> [UInt16] {
        return [UInt16](unsafeUninitializedCapacity: lookupTableElementCount) {
            buffer, count in

            /// Supply the samples in the range `0...65535`, the transform function
            /// interpolates these to the range `0...1`.
            let multiplier = CGFloat(UInt16.max)
            var bufferIndex = 0

            for red in ( 0 ..< entriesPerChannel) {
                for green in ( 0 ..< entriesPerChannel) {
                    for blue in ( 0 ..< entriesPerChannel) {

                        /// Create normalized red, green, and blue values in the range `0...1`.
                        let normalizedRed = CGFloat(red) / CGFloat(entriesPerChannel - 1)
                        let normalizedGreen = CGFloat(green) / CGFloat(entriesPerChannel - 1)
                        let normalizedBlue = CGFloat(blue) / CGFloat(entriesPerChannel - 1)

                        /// Create an RGB color object for this point in the RGB cube.
                        let rgb = CGColor(red: normalizedRed,
                                          green: normalizedGreen,
                                          blue: normalizedBlue,
                                          alpha: 1)

                        /// Create a CMYK representation of the RGB color.
                        let cmyk = rgb.converted(to: CGColorSpaceCreateDeviceCMYK(),
                                                 intent: .perceptual,
                                                 options: nil)

                        /// Append the cyan, magenta, yellow, and black components to the buffer.
                        buffer[ bufferIndex ] = UInt16(cmyk!.components![0] * multiplier)
                        bufferIndex += 1
                        buffer[ bufferIndex ] = UInt16(cmyk!.components![1] * multiplier)
                        bufferIndex += 1
                        buffer[ bufferIndex ] = UInt16(cmyk!.components![2] * multiplier)
                        bufferIndex += 1
                        buffer[ bufferIndex ] = UInt16(cmyk!.components![3] * multiplier)
                        bufferIndex += 1
                    }
                }
            }

            count = lookupTableElementCount
        }
    }


    fileprivate func createSmallTableData(_ lookupTableElementCount: Int, _ entriesPerChannel: UInt8) -> [UInt16] {
        return [UInt16](unsafeUninitializedCapacity: lookupTableElementCount) {
            buffer, count in

            let multiplier = Float(UInt16.max)
            var bufferIndex = 0

            for red in ( 0 ..< entriesPerChannel) {
                for green in ( 0 ..< entriesPerChannel) {
                    for blue in ( 0 ..< entriesPerChannel) {

                        let normalizedRed = Float(red) / Float(entriesPerChannel - 1)
                        let normalizedGreen = Float(green) / Float(entriesPerChannel - 1)
                        let normalizedBlue = Float(blue) / Float(entriesPerChannel - 1)

                        let gray = (normalizedRed * 0.2126) +
                        (normalizedGreen * 0.7152) +
                        (normalizedBlue * 0.0722)

                        buffer[ bufferIndex ] = UInt16(gray * multiplier)
                        bufferIndex += 1
                    }
                }
            }

            count = lookupTableElementCount
        }
    }

    func smallSample() async throws -> CGImage? {
        // https://developer.apple.com/documentation/accelerate/1544435-vimagemultidimensionaltable_crea
        let entriesPerChannel = UInt8(32)
        let srcChannelCount = 3
        let destChannelCount = 1

        let lookupTableElementCount = Int(pow(Float(entriesPerChannel), Float(srcChannelCount))) * Int(destChannelCount)
        let tableData = createSmallTableData(lookupTableElementCount, entriesPerChannel)
        let entryCountPerSourceChannel = [UInt8](repeating: entriesPerChannel, count: srcChannelCount)
        var error = kvImageNoError

        guard let lookupTable = vImageMultidimensionalTable_Create(
            tableData,
            UInt32(srcChannelCount),
            UInt32(destChannelCount),
            entryCountPerSourceChannel,
            kvImageMDTableHint_Float,
            vImage_Flags(kvImageNoFlags),
            &error) else {
            fatalError("Unable to create multidimensional table \(error).")
        }

        defer {
            vImageMultidimensionalTable_Release(lookupTable)
        }

        // https://developer.apple.com/documentation/accelerate/1546728-vimagemultidimensionalinterpolat
        let size = vImage.Size(width: 1, height: 3)


        let red = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [1, 0, 0],
            size: size)
        let green = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [0, 1, 0],
            size: size)
        let blue = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [0, 0, 1],
            size: size)


        let source = vImage.PixelBuffer<vImage.PlanarFx3>(
            planarBuffers: [red, green, blue])


        let destination = vImage.PixelBuffer<vImage.PlanarF>(
            size: size)


        source.withUnsafeVImageBuffers { src in
            destination.withUnsafeVImageBuffer { dest in

                _ = vImageMultiDimensionalInterpolatedLookupTable_PlanarF(
                    src,
                    [dest],
                    nil,
                    lookupTable,
                    kvImageFullInterpolation,
                    vImage_Flags(kvImageNoFlags))
            }
        }

        // Prints "[0.2125887, 0.71519035, 0.072190434]".
        print(destination.array)

        // https://stackoverflow.com/a/73207222/3199999

        let buffer = vImage.PixelBuffer<vImage.Interleaved8x4>(
            size: .init(width: 640, height: 480)
        )

        buffer.withUnsafeMutableBufferPointer { bufferPtr in
            for x in 0 ..< buffer.width  {
                for y in 0 ..< buffer.height {

                    let rowBytes = (buffer.rowStride * buffer.byteCountPerPixel)
                    let index = y*rowBytes + x*buffer.channelCount

                    let red = Pixel_8(Float(x) / Float(buffer.width) * 255)
                    let blue = Pixel_8(Float(y) / Float(buffer.height) * 255)

                    bufferPtr[index + 0] = red
                    bufferPtr[index + 1] = 0 // green
                    bufferPtr[index + 2] = blue
                    bufferPtr[index + 3] = 0 // alpha
                }
            }
        }

        let format = vImage_CGImageFormat(bitsPerComponent: 8,
                                          bitsPerPixel: 8 * 4,
                                          colorSpace: CGColorSpaceCreateDeviceRGB(),
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue))!

        let image = buffer.makeCGImage(cgImageFormat: format)
        return image
    }

    func createLutData(image: CIImage) async throws -> CGImage? {
        let context = CIContext()
        guard let sourceImage = context.createCGImage(image, from: image.extent) else {
            print("failed make source image ❌")
            return nil }

        /// Create Lookup Table data
        /// https://developer.apple.com/documentation/accelerate/applying_color_transforms_to_images_with_a_multidimensional_lookup_table
        let entriesPerChannel = UInt8(16)
        let srcChannelCount = UInt32(3)
        let destChannelCount = UInt32(4)


        let lookupTableElementCount = Int(pow(Float(entriesPerChannel), Float(srcChannelCount))) * Int(destChannelCount)

        let tableData = createTableData(lookupTableElementCount, entriesPerChannel)

        var error = kvImageNoError


        let tableEntriesPerDimension = [UInt8](repeating: entriesPerChannel,
                                               count: Int(srcChannelCount))
        guard let lookupTable = vImageMultidimensionalTable_Create(
            tableData,
            srcChannelCount,
            destChannelCount,
            tableEntriesPerDimension,
            kvImageMDTableHint_Float,
            vImage_Flags(kvImageNoFlags),
            &error) else {
            fatalError("Unable to create multidimensional table \(error).")
        }


        defer {
            vImageMultidimensionalTable_Release(lookupTable)
        }

        let size = vImage.Size(width: 1, height: 3)


        let red = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [1, 0, 0],
            size: size)
        let green = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [0, 1, 0],
            size: size)
        let blue = vImage.PixelBuffer<vImage.PlanarF>(
            pixelValues: [0, 0, 1],
            size: size)


        // let source = vImage.PixelBuffer<vImage.PlanarFx3>(
        //     planarBuffers: [red, green, blue])

        let inputSourceBuffer: vImage_Buffer = try vImage_Buffer(cgImage: sourceImage)
        var inputPointerSourceBuffer = withUnsafePointer(to: inputSourceBuffer) { pointer in
            return pointer
        }


        let destination = vImage.PixelBuffer<vImage.PlanarF>(
            size: size)

        // inputPointerSourceBuffer.withUnsafeVImageBuffers { src in
        destination.withUnsafeVImageBuffer { dest in

            _ = vImageMultiDimensionalInterpolatedLookupTable_PlanarF(
                inputPointerSourceBuffer,
                [dest],
                nil,
                lookupTable,
                kvImageFullInterpolation,
                vImage_Flags(kvImageNoFlags))
        }
        // }

        // Prints "[0.2125887, 0.71519035, 0.072190434]".
        print(destination.array)
        return nil

        // var cgImageFormat = vImage_CGImageFormat(
        //     bitsPerComponent: 8,
        //     bitsPerPixel: 8 * 3,
        //     colorSpace: CGColorSpaceCreateDeviceRGB(),
        //     bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue))!
        //
        //
        // /// Input
        // let inputSourceBuffer: vImage_Buffer = try vImage_Buffer(cgImage: sourceImage)
        // var inputPointerSourceBuffer = withUnsafePointer(to: inputSourceBuffer) { pointer in
        //     return pointer
        // }
        //
        // /// Output, TODO: change CGImage?
        // let outputSourceBuffer: vImage_Buffer = try vImage_Buffer(cgImage: sourceImage)
        // var outputPointerSourceBuffer = withUnsafePointer(to: outputSourceBuffer) { pointer in
        //     return pointer
        // }
        //
        // vImage.pla
        //
        // error = vImageMultiDimensionalInterpolatedLookupTable_PlanarF(
        //     inputPointerSourceBuffer,
        //     outputPointerSourceBuffer,
        //     nil,
        //     lookupTable,
        //     kvImageFullInterpolation,
        //     vImage_Flags(kvImageNoFlags))
        //
        // if error != kvImageNoError {
        //     fatalError("Error calling transform function` \(error).")
        // }
        //
        // let result = try? outputPointerSourceBuffer.pointee.createCGImage(format: .init(cgImage: sourceImage)!)
        // return result

        /// Convert an interleaved source buffer to planar buffers
        /// source: https://developer.apple.com/documentation/accelerate/optimizing_image-processing_performance

        // var cgImageFormat = vImage_CGImageFormat(
        //     bitsPerComponent: 8,
        //     bitsPerPixel: 8 * 3,
        //     colorSpace: CGColorSpaceCreateDeviceRGB(),
        //     bitmapInfo: CGBitmapInfo(rawValue:
        //                                 CGImageAlphaInfo.none.rawValue))!
        //
        //
        // let sourceBuffer = try vImage.PixelBuffer(cgImage: sourceImage,
        //                                           cgImageFormat: &cgImageFormat,
        //                                           pixelFormat: vImage.Interleaved8x3.self)
        // let sourceRedBuffer = vImage.PixelBuffer(size: sourceBuffer.size,
        //                                          pixelFormat: vImage.Planar8.self)
        // let sourceGreenBuffer = vImage.PixelBuffer(size: sourceBuffer.size,
        //                                            pixelFormat: vImage.Planar8.self)
        // let sourceBlueBuffer = vImage.PixelBuffer(size: sourceBuffer.size,
        //                                           pixelFormat: vImage.Planar8.self)
        //
        //
        // sourceBuffer.deinterleave(planarDestinationBuffers: [sourceRedBuffer,
        //                                                      sourceGreenBuffer,
        //                                                      sourceBlueBuffer])
        //
        // /// Initialize the destination buffers
        //
        // let destinationBuffer = vImage.PixelBuffer(size: .init(width: sourceBuffer.width / 10,
        //                                                        height: sourceBuffer.height / 10),
        //                                            pixelFormat: vImage.Interleaved8x3.self)
        //
        //
        // let destinationRedBuffer = vImage.PixelBuffer(size: destinationBuffer.size,
        //                                               pixelFormat: vImage.Planar8.self)
        // let destinationGreenBuffer = vImage.PixelBuffer(size: destinationBuffer.size,
        //                                                 pixelFormat: vImage.Planar8.self)
        // let destinationBlueBuffer = vImage.PixelBuffer(size: destinationBuffer.size,
        //                                                pixelFormat: vImage.Planar8.self)
        //
        // /// Apply the scale operation to the planar buffers
        // let time = await ContinuousClock().measure {
        //     await withTaskGroup(of: Void.self) { group in
        //         group.addTask(priority: .userInitiated) {
        //             sourceRedBuffer.scale(destination: destinationRedBuffer)
        //         }
        //
        //         group.addTask(priority: .userInitiated) {
        //             sourceGreenBuffer.scale(destination: destinationGreenBuffer)
        //         }
        //
        //         group.addTask(priority: .userInitiated) {
        //             sourceBlueBuffer.scale(destination: destinationBlueBuffer)
        //         }
        //     }
        //
        //     destinationBuffer.interleave(planarSourceBuffers: [destinationRedBuffer,
        //                                                        destinationGreenBuffer,
        //                                                        destinationBlueBuffer])
        // }
        //
        // let scaledImage = destinationBuffer.makeCGImage(cgImageFormat: cgImageFormat)
        // return scaledImage
    }
}

// extension CIImage {
//     // https://github.com/silence0201/CIFilterExtensions/blob/27744ef0891626e5205e296a4f29af63546dfd0a/CIFilterExtensions/ColorEffect/CIColorCubeFilter.swift#L35
//
//     public func colorCubeFilter(cubeDimension: NSNumber = 2, cubeData: Data) -> CIImage? {
//         guard let filter = CIFilter(name: "CIColorCube") else { return nil }
//         filter.setValue(self, forKey: "inputImage")
//         filter.setValue(cubeDimension, forKey: "inputCubeDimension")
//         filter.setValue(cubeData, forKey: "inputCubeData")
//         return filter.outputImage
//     }
//
// }
