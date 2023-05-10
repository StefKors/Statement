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
        HStack {
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
            .safeAreaInset(edge: .bottom, content: {
                ViewTypeSwitcherView()
            })
            .padding()
            .dottedBackgroundPattern()
            .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: model.viewPreference)

            if case let .success(image) = model.imageState {
                VStack {
                    Form {
                        SepiaFilterControlsView(image: image)
                        ColorCubeFilterControlsView(image: image)
                        AdjustableColorCubeFilterControlsView(image: image)
                        ExifDataView(exif: image.exif)
                        ExportControlsView()
                    }
                    .formStyle(.grouped)
                    .frame(width: 280)
                }
            }
        }
        .scenePadding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
