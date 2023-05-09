//
//  SideBySideView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct SideBySideView: View {
    @EnvironmentObject private var model: Model
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Original")
                ImageView(imageState: model.imageState)
                    .scaledToFit()
                    .cornerRadius(8)
            }

            if model.filteredImageState.image != nil {
                VStack(alignment: .leading) {
                    Text("Edited")
                    ImageView(imageState: model.filteredImageState)
                        .scaledToFit()
                        .cornerRadius(8)
                }
            }
        }
    }
}

struct SideBySideView_Previews: PreviewProvider {
    static var previews: some View {
        SideBySideView()
    }
}
