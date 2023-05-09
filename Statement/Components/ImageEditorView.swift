//
//  ImageEditorView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ImageEditorView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var colorCubeFilter: ColorCubeModel
    @EnvironmentObject private var adjustableColorCubeFilter: AdjustableColorCubeModel
    @EnvironmentObject private var sepiaFilter: SepiaModel

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ResizableView(
                    fullContent: {
                        ImageView(imageState: model.imageState)
                            .scaledToFit()
                    },
                    clippedContent: {
                        ZStack {
                            if let image = model.filteredImageState.image {
                                ImageView(imageState: model.filteredImageState)
                                    .scaledToFit()
                            }
                        }
                    })
            }
        }
        .toolbar(content: {
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
        })

        .scenePadding()

    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView()
    }
}
