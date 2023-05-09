//
//  ColorCubeFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct LutImagePickerView: View {
    @EnvironmentObject private var model: Model

    let lut: LutImage
    let isSelected: Bool

    var color: Color {
        if isSelected {
            if model.enabledFilter == .colorCube {
                return Color.accentColor
            }

            return Color.secondary
        }

        return Color.clear

    }

    var body: some View {
        HStack {
            Spacer()
            Image(lut.rawValue)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(color, lineWidth: 3)
                }
                .shadow(color: color, radius: 5, x: 0, y: 2)
            Spacer()
        }
    }
}

struct ColorCubeFilterControlsView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var filterModel: ColorCubeModel

    var image: EditorImage? = nil

    private let step: Float.Stride = 0.1

    var body: some View {
        Section {
            HStack {
                ForEach(LutImage.allCases, id: \.self) { lut in
                    LutImagePickerView(lut: lut, isSelected: filterModel.selectedImage == lut)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                filterModel.selectedImage = lut
                                guard let image else { return }
                                model.enabledFilter = filterModel.type
                                model.filteredImageState = filterModel.processImage(image)
                            }
                        }
                }
            }
        } header: {
            Text("ColorCube Filter")
        }
        .disabled(image == nil)
    }
}

struct ColorCubeFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCubeFilterControlsView(image: nil)
    }
}
