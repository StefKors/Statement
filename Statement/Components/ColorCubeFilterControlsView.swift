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
                ForEach([LutImage.lut1, LutImage.lut2, LutImage.lut3], id: \.self) { lut in
                    LutImagePickerView(lut: lut, isSelected: filterModel.selectedImage == lut)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                filterModel.selectedImage = lut
                                model.enabledFilter = filterModel.type
                                model.filteredImageState = filterModel.processImage(image)
                            }
                        }
                }

                ZStack {
                    switch filterModel.imageState {
                    case .empty:
                        GroupBox {
                            ZStack {
                                Color.windowBackgroundColor
                                Image(systemName: "photo")
                            }
                            .onTapGesture {
                                isPresented.toggle()
                            }
                        }

                    default:
                        ImageView(imageState: filterModel.imageState)
                            .lutImageStyle(filterModel.selectedImage == .custom)
                            .font(.system(size: 8))
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.15)) {
                                    filterModel.selectedImage = .custom
                                }
                            }
                    }
                }
                .onChange(of: filterModel.selectedImage, perform: { newValue in
                    if newValue == .custom {
                        withAnimation(.easeIn(duration: 0.15)) {
                            model.enabledFilter = filterModel.type
                            let result = filterModel.processImage(image)
                            if case .success = result {
                                model.filteredImageState = result
                            }
                        }
                    }
                })
                .photosPicker(isPresented: $isPresented, selection: $filterModel.imageSelection, matching: .images)
                .overlay(alignment: .bottom) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .buttonStyle(.borderedProminent)
                    .labelStyle(.iconOnly)
                    .help("Choose custom LUT Image")
                    .offset(y: 5)
                }
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
