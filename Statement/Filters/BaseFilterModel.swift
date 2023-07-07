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

    /// Process provided image and apply filter
    /// - Parameter image: image to process
    func processImage(_ image: EditorImage) -> ImageState {
        // Data to CIImage
        guard let inputImage = CIImage(data: image.data, options: [.applyOrientationProperty:true]) else { return .empty }
        // Apply filter to CIImage
        guard let outputImage = applyFilter(inputImage) else { return .empty }
        // CIImage to CGImage
        guard let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else { return .empty }
        // CGImage to NSImage
        let nsImage = NSImage(cgImage: cgImage, size: outputImage.extent.size)
        // NSImage to SwiftUI Image
        let image = Image(nsImage: nsImage)
        // NSImage to Data
        guard let data = nsImage.tiffRepresentation else { return .empty }
        // Get Exif from Data
        let exif = Exif(data: data)
        // Create EditorImage
        let editorImage = EditorImage(image: image, ciImage: inputImage, data: data, exif: exif)
        // Update Image State
        return .success(editorImage)
    }

    /// Override to apply parent class filter, otherwise returns unedited image
    func applyFilter(_ inputImage: CIImage) -> CIImage? {
        return inputImage
    }
}
