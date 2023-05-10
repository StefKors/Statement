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
    let data: Data
    let exif: Exif
    let id: UUID = UUID()

    var nsImage: NSImage? {
        NSImage(data: data)
    }

    var document: ImageDocument {
        ImageDocument(image: self.nsImage)
    }

    func makeDocument(_ exportCompression: NSBitmapImageRep.TIFFCompression) -> ImageDocument {
        ImageDocument(image: self.nsImage, compression: exportCompression)
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let nsImage = NSImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(nsImage: nsImage)
            let exif = Exif(data: data)
            return EditorImage(image: image, data: data, exif: exif)
        }
    }
}

extension EditorImage {
    static let preview: EditorImage = .init(image: Image(systemName: "dot"), data: Data(), exif: Exif())
}
