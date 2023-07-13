//
//  EditorImage.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

enum TransferError: Error {
    case importFailed
}

struct EditorImage: Transferable, Identifiable {
    let image: Image
    let ciImage: CIImage
    let nsImage: NSImage
    let data: Data
    let exif: Exif
    let id: UUID = UUID()

    var document: ImageDocument {
        print("document")
        let nsImage = NSImage(data: data)
        return ImageDocument(image: nsImage)
    }

    func makeDocument(_ exportCompression: NSBitmapImageRep.TIFFCompression) -> ImageDocument {
        print("makeDocument")
        let nsImage = NSImage(data: data)
        return ImageDocument(image: nsImage, compression: exportCompression)
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let nsImage = NSImage(data: data), let ciImage = CIImage(data: data, options: [.applyOrientationProperty:true]) else {
                throw TransferError.importFailed
            }
            let image = Image(nsImage: nsImage)
            let exif = Exif(data: data)
            return EditorImage(
                image: image,
                ciImage: ciImage,
                nsImage: nsImage,
                data: data,
                exif: exif
            )
        }
    }
}

extension EditorImage {
    static let preview: EditorImage = .init(
        image: Image(systemName: "dot"),
        ciImage: CIImage(color: .blue),
        nsImage: NSImage(),
        data: Data(),
        exif: Exif()
    )
}
