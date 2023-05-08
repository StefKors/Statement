//
//  OpenPhotosButtonView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI
import PhotosUI

struct OpenPhotosButtonView: View {
    @EnvironmentObject private var model: Model

    @State private var isHovering: Bool = false
    @State private var isPresented: Bool = false

    var body: some View {
        VStack {
            PaperStackView(hover: isHovering)

            Button("Open Photo") {
                isPresented.toggle()
            }
        }
        .onHover { hoverState in
            isHovering = hoverState
        }
        .onTapGesture {
            isPresented.toggle()
        }
        .photosPicker(isPresented: $isPresented, selection: $model.imageSelection, matching: .images)
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button("Open Photo") {
                    isPresented.toggle()
                }
            }
        })
    }
}

struct OpenPhotosButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPhotosButtonView()
    }
}
