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
            return currentFilter.outputImage
        case .ColorCube:
            let currentFilter = CIFilter.colorCube()
            guard let data = getLutData() else { return nil }
            currentFilter.cubeData = data
            currentFilter.cubeDimension = 8.0
            currentFilter.inputImage = inputImage
            currentFilter.extrapolate = true
            return currentFilter.outputImage
        }


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
