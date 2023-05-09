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
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                ResizableView(
                    fullContent: {
                        ImageView(imageState: model.imageState)
                            .scaledToFit()
                    },
                    clippedContent: {
                        ZStack {
                            ImageView(imageState: model.filterImageState)
                                .scaledToFit()
                                // .blendMode(.colorDodge)
                                .overlay {
                                    Rectangle().stroke(lineWidth: 20)
                                }

                            if let image = model.editedImage {
                                image
                                    .scaledToFit()
                                    .frame(width: 400, height: 400)
                            } else {
                                Text("❌")
                            }

                        }
                    })

                VStack(alignment: .leading) {
                    ForEach(Model.ImageFilter.allCases, id: \.self) { filter in
                        Button {
                            model.applyFilter(type: filter)
                        } label: {
                            Label("Apply \(filter.rawValue)", systemImage: "camera.filters")
                        }
                    }
                }
            }

            HStack {
                ImageSpecView(label: "\u{0192}1.8")
                ImageSpecView(label: "1/2500s")
                ImageSpecView(label: "ISO 20", systemImage: "camera.aperture")
            }
            .fontDesign(.monospaced)

        }
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                OpenPhotosToolbarButtonView()
            }

            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    withAnimation(.spring()) {
                        model.imageSelection = nil
                    }
                } label: {
                    Label("Clean Selection", systemImage: "trash")
                }
                .foregroundStyle(.red)
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
