//
//  LutImagePickerView.swift
//  Statement
//
//  Created by Stef Kors on 10/05/2023.
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
        Image(lut.rawValue)
            .resizable()
            .scaledToFill()
            .frame(width: 63, height: 63)
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: 3)
            }
            .shadow(color: color, radius: 5, x: 0, y: 2)
    }
}

struct LutImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            LutImagePickerView(lut: .lut1, isSelected: false)
            LutImagePickerView(lut: .lut2, isSelected: true)
            LutImagePickerView(lut: .lut3, isSelected: false)
        }
        .scenePadding()
    }
}
