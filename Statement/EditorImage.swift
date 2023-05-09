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
