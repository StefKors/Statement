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
            switch model.viewPreference {
            case .sideBySide:
                SideBySideView()
            case .stacked:
                StackedView()
            }
        }
        .task {
            guard let image = model.imageState.image else { return }
            switch model.enabledFilter {
            case .adjustableColorCube:
                self.model.filteredImageState = adjustableColorCubeFilter.processImage(image)
            case .colorCube:
                self.model.filteredImageState = colorCubeFilter.processImage(image)
            case .sepia:
                self.model.filteredImageState = sepiaFilter.processImage(image)
            case .none:
                print("do nothing")
            }
        }
        .toolbar(content: {
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
        })

        .scenePadding()

    }
}

struct ImageEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ImageEditorView()
    }
}
