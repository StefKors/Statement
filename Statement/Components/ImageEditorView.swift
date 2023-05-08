//
//  ImageEditorView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ImageEditorView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        ZStack {
            ImageView(imageState: model.imageState)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 6))

            ImageView(imageState: model.imageState)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .blur(radius: 40)
        }
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                OpenPhotosToolbarButtonView()
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
