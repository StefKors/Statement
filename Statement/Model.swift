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

@MainActor
class Model: ObservableObject {
    internal init() {
        if let data = storage {
            guard let nsImage = NSImage(data: data) else {
                return
            }
            let image = Image(nsImage: nsImage)
            self.imageState = .success(EditorImage(image: image, data: data))
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

    @AppStorage("imageDataStorage") var storage: Data?

    @Published private(set) var imageState: ImageState = .empty

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
                    self.storage = editorImage.data
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

