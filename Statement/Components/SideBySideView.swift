//
//  SideBySideView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import AppKit

struct SideBySideView<Content: View>: View {
    @EnvironmentObject private var model: Model

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
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
                Text("Edited")
                    content()
                    .scaledToFit()
                    .cornerRadius(8)
            }
        }
    }
}

struct SideBySideView_Previews: PreviewProvider {
    static var previews: some View {
        SideBySideView {
            Image(systemName: "dot.fill")
        }
    }
}
