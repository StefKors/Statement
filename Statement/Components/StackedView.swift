//
//  StackedView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct StackedView: View {
    @EnvironmentObject private var model: Model
    
    var body: some View {
        HStack(alignment: .top) {
            ResizableView(
                fullContent: {
                    ImageView(imageState: model.imageState)
                        .scaledToFit()
                },
                clippedContent: {
                    ZStack {
                        if model.filteredImageState.image != nil {
                            ImageView(imageState: model.filteredImageState)
                                .scaledToFit()
                        }
                    }
                })
        }
    }
}

struct StackedView_Previews: PreviewProvider {
    static var previews: some View {
        StackedView()
    }
}
