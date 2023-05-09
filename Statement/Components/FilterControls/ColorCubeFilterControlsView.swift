//
//  ColorCubeFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct LutImagePickerView: View {
    let lut: LutImage
    let isSelected: Bool

    var body: some View {
        HStack {
            Spacer()
            Image(lut.rawValue)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.accentColor, lineWidth: 3)
                    }
                }
                .shadow(color: isSelected ? Color.accentColor : .clear, radius: 5, x: 0, y: 2)
            Spacer()
        }
    }
}

struct ColorCubeFilterControlsView: View {
    @EnvironmentObject private var model: ColorCubeModel

    var image: EditorImage? = nil

    private let step: Float.Stride = 0.1

    var body: some View {
        Section {
            Toggle("Show/Hide", isOn: $model.showFilter)

            HStack {
                ForEach(LutImage.allCases, id: \.self) { lut in
                    LutImagePickerView(lut: lut, isSelected: model.selectedImage == lut)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                model.selectedImage = lut
                                if let image {
                                    model.processImage(image)
                                }
                            }
                        }
                }
            }

            Button("Apply Filter") {
                guard let image else { return }
                model.processImage(image)
            }
            .disabled(image == nil)
        } header: {
            Text("ColorCube Filter")
        }
    }
}

struct ColorCubeFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCubeFilterControlsView(image: nil)
    }
}
