//
//  ImageEditorView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ImageLayoutView: View {
    let ciImage: CIImage
    let viewPreference: ViewType

    var body: some View {
        switch viewPreference {
        case .sideBySide:
            SideBySideView {
                EditedImageView(ciImage: ciImage)
            }
        case .stacked:
            StackedView {
                EditedImageView(ciImage: ciImage)
            }
        }
    }
}


struct ImageEditorView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var sepiaFilter: SepiaModel

    var body: some View {
        VStack(alignment: .leading) {
            if let ciImage = model.imageState.image?.ciImage {
                ImageLayoutView(ciImage: ciImage, viewPreference: model.viewPreference)
                    .frame(minWidth: 300, maxWidth: 1400, minHeight: 300, maxHeight: 1400, alignment: .center)
                    .id(model.imageState.image?.id)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                CancelFilterButtonView()
            }

            ToolbarItem(placement: .primaryAction) {
                OpenPhotosToolbarButtonView()
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
