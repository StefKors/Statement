//
//  ImageState.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import Foundation

enum ImageState {
    case empty
    case loading(Progress)
    case success(EditorImage)
    case failure(Error)

    var image: EditorImage? {
        guard case let .success(image) = self else { return nil }
        return image
    }
}
