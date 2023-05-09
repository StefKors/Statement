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
            .padding()
            .dottedBackgroundPattern()

            VStack {
                Form {
                    SepiaFilterControlsView(image: model.imageState.image)
                    ColorCubeFilterControlsView(image: model.imageState.image)

                    if let exif =  model.imageState.image?.exif {
                        Section("Exif Data") {
                            ExifDataView(exif: exif)
                        }

                    }
                }
                .formStyle(.grouped)
                .frame(width: 280)
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
