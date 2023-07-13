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


enum ViewType: String, CaseIterable, Identifiable {
    case stacked
    case sideBySide
    var id: Self { self }
}

@MainActor
class Model: ObservableObject {
    internal init() {
        if let data = imageStorage {
            guard let nsImage = NSImage(data: data), let ciImage = CIImage(data: data, options: [.applyOrientationProperty:true]) else {
                return
            }
            let image = Image(nsImage: nsImage)
            let exif = Exif(data: data)

            self.imageState = .success(EditorImage(image: image, ciImage: ciImage, nsImage: nsImage, data: data, exif: exif))
        }
    }

    // Persist Image
    @AppStorage("imageDataStorage") var imageStorage: Data?
    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            withAnimation(.easeIn(duration: 0.15)) {
                // Reset Filter
                if let imageSelection {
                    let progress = loadTransferable(from: imageSelection)
                    imageState = .loading(progress)
                } else {
                    imageState = .empty
                }
            }
        }
    }
    @AppStorage("viewPreference") var viewPreference: ViewType = .stacked

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: EditorImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                withAnimation(.easeIn(duration: 0.15)) {
                    switch result {
                    case .success(let editorImage?):
                        self.imageState = .success(editorImage)
                        self.imageStorage = editorImage.data
                    case .success(nil):
                        self.imageState = .empty
                    case .failure(let error):
                        self.imageState = .failure(error)
                    }
                }
            }
        }
    }
}
