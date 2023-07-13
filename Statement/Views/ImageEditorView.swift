//
//  ImageEditorView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

private struct CurrentImage: EnvironmentKey {
    static let defaultValue = CIImage(color: .blue)
}

extension EnvironmentValues {
    var currentImage: CIImage {
        get { self[CurrentImage.self] }
        set { self[CurrentImage.self] = newValue }
    }
}

struct ImageEditorView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        VStack(alignment: .leading) {
            if let ciImage = model.imageState.image?.ciImage {
                ImageLayoutView(ciImage: ciImage, viewPreference: model.viewPreference)
                    .environment(\.currentImage, ciImage)
                    .id(model.imageState.image?.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                CancelFilterButtonView()
            }

            ToolbarItem(placement: .primaryAction) {
                OpenPhotosToolbarButtonView(selection: $model.imageSelection)
            }

            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    withAnimation(.spring()) {
                        model.imageSelection = nil
                    }
                } label: {
                    Label("Clean Selection", systemImage: "trash")
                }
                .foregroundStyle(.red)
            }
        }

        .scenePadding()

    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView()
    }
}
