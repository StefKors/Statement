//
//  BaseFilterModel.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//
//  Filter code based on: https://www.hackingwithswift.com/books/ios-swiftui/integrating-core-image-with-swiftui

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class BaseFilterModel: Identifiable {
    let id = UUID()
    @Published private(set) var imageState: ImageState = .empty
    @Published var showFilter: Bool = false

    /// Process provided image and apply filter
    /// - Parameter image: image to process
    func processImage(_ image: EditorImage) {
        // Data to CIImage
        guard let inputImage = CIImage(data: image.data) else { return }
        // Apply filter to CIImage
        guard let outputImage = applyFilter(inputImage) else { return }
        // CIImage to CGImage
        guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return }
        // CGImage to NSImage
        let nsImage = NSImage(cgImage: cgImage, size: outputImage.extent.size)
        // NSImage to SwiftUI Image
        let image = Image(nsImage: nsImage)
        // NSImage to Data
        guard let data = nsImage.tiffRepresentation else { return }
        // Get Exif from Data
        let exif = Exif(data: data)
        // Create EditorImage
        let editorImage = EditorImage(image: image, data: data, exif: exif)
        // Update Image State
        self.imageState = .success(editorImage)
        // Show Filter layer
        self.showFilter = true
    }

    /// Override to apply parent class filter, otherwise returns unedited image
    func applyFilter(_ inputImage: CIImage) -> CIImage? {
        return inputImage
    }
}
