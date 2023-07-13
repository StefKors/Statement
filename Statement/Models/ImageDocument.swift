//
//  ImageDocument.swift
//  Statement
//
//  Created by Stef Kors on 10/05/2023.
//

import SwiftUI
import UniformTypeIdentifiers

// based on: https://developer.apple.com/forums/thread/672952
struct ImageDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [
            .png,
            .jpeg,
            .tiff,
            .heic
        ]
    }

    static var exportCompressionTypes: [NSBitmapImageRep.TIFFCompression] {
        [
            .none,
            .ccittfax3,
            .ccittfax4,
            .lzw,
            .jpeg,
            .next,
            .packBits,
            .oldJPEG
        ]
    }

    var image: NSImage
    var compression: NSBitmapImageRep.TIFFCompression = .none
    // var type: UTType = .png

    init(image: NSImage?) {
        self.image = image ?? NSImage()
    }

    init(image: NSImage?, compression: NSBitmapImageRep.TIFFCompression) {
        self.image = image ?? NSImage()
        self.compression = compression
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let image = NSImage(data: data) else { throw CocoaError(.fileReadCorruptFile) }
        self.image = image
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        /* You can replace tiff representation with what you want to export */
        return FileWrapper(regularFileWithContents: image.tiffRepresentation(using: compression, factor: 1)!)
    }
}
