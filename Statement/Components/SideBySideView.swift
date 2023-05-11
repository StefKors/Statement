//
//  SideBySideView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct SideBySideView: View {
    @EnvironmentObject private var model: Model

    var editedImageWithFallback: ImageState {
        if model.filteredImageState.image != nil {
            return model.filteredImageState
        } else {
            return model.imageState
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Original")
                ImageView(imageState: model.imageState)
                    .scaledToFit()
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text("Edited ") + Text(model.enabledFilter.rawValue).foregroundColor(.secondary)
                ImageView(imageState: editedImageWithFallback)
                    .scaledToFit()
                    .cornerRadius(8)
            }
        }
    }
}

struct SideBySideView_Previews: PreviewProvider {
    static var previews: some View {
        SideBySideView()
    }
}
