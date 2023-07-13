//
//  OpenPhotosToolbarButtonView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI
import PhotosUI

struct OpenPhotosToolbarButtonView: View {
    @Binding var selection: PhotosPickerItem?

    @State private var isPresented: Bool = false
    
    var body: some View {
        Button("Open Photo") {
            isPresented.toggle()
        }
        .photosPicker(isPresented: $isPresented, selection: $selection, matching: .images)
    }
}

struct OpenPhotosToolbarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPhotosToolbarButtonView(selection: .constant(nil))
    }
}
