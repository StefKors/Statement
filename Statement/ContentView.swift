//
//  ContentView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI
import PhotosUI
import HistogramView

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
            .dottedBackgroundPattern()
            .safeAreaInset(edge: .bottom, content: {
                ViewTypeSwitcherView()
            })
            .padding()
            .animation(.interpolatingSpring(stiffness: 300, damping: 20), value: model.viewPreference)

            if case let .success(image) = model.imageState {

                VStack {
                    Form {
                        InspectorRenderer()
                            .environment(\.currentImage, image.ciImage)
                        ExifDataView(exif: image.exif)
                        Section("Histogram (Source Image)") {
                            HistogramView(image: image.nsImage, blendMode: .multiply)
                                .frame(height: 100)
                        }
                        ExportControlsView()
                            .environment(\.currentImage, image.ciImage)
                    }.formStyle(.grouped)
                }
                .frame(width: 300)
                .transition(.move(edge: .trailing).combined(with: .opacity))
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
