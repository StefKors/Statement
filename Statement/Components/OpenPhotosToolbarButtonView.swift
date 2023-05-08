//
//  OpenPhotosToolbarButtonView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct OpenPhotosToolbarButtonView: View {
    @EnvironmentObject private var model: Model

    @State private var isPresented: Bool = false
    
    var body: some View {
        Button("Open Photo") {
            isPresented.toggle()
        }
        .photosPicker(isPresented: $isPresented, selection: $model.imageSelection, matching: .images)
    }
}

struct OpenPhotosToolbarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPhotosToolbarButtonView()
    }
}
