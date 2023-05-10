//
//  ColorCubeFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct ColorCubeFilterControlsView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var filterModel: ColorCubeModel
    @State private var isPresented: Bool = false

    var image: EditorImage

    private let step: Float.Stride = 0.1
    var body: some View {
        Section {
            HStack {
                ForEach(LutImage.allCases, id: \.self) { lut in
                    LutImagePickerView(lut: lut, isSelected: filterModel.selectedImage == lut)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                filterModel.selectedImage = lut
                                model.enabledFilter = filterModel.type
                                model.filteredImageState = filterModel.processImage(image)
                            }
                        }
                }

                GroupBox {
                    switch filterModel.imageState {
                    case .empty:
                        Color.windowBackgroundColor

                    default:
                        ImageView(imageState: filterModel.imageState)
                    }

                }
                .overlay(content: {
                    ZStack {
                        Color.windowBackgroundColor.opacity(0.4)
                        Image(systemName: "folder.fill.badge.plus")
                            .onTapGesture {
                                isPresented.toggle()
                            }
                    }
                })
                .frame(width: 63, height: 63)
                .photosPicker(isPresented: $isPresented, selection: $filterModel.imageSelection, matching: .images)
            }
        } header: {
            Text("ColorCube Filter")
        }
    }
}

struct ColorCubeFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCubeFilterControlsView(image: .preview)
    }
}
