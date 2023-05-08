//
//  ContentView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.clear)

            switch model.imageState {
            case .empty:
                OpenPhotosButtonView()
                    .navigationSubtitle("Open Photo")

            default:
                ImageEditorView()
                    .navigationSubtitle("Edit Photo")
            }
        }
        .dottedBackgroundPattern()
        .scenePadding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
