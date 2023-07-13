//
//  EditedImageView.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI
import SwiftUICoreImage

struct ImageSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    var body: some View {
        Slider(
            value: $value,
            in: range
        ) {
            Text("Intensity")
        }
    }
}

struct EditedImageView: View {
    var ciImage: CIImage
    @EnvironmentObject private var inspector: InspectorModel

    var body: some View {
        VStack {
            Image(ciImage: inspector.makeEditedImage(ciImage: ciImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .id("edited-image")
        }
    }
}
struct EditedImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditedImageView(ciImage: CIImage(color: .blue))
    }
}
