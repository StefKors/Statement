//
//  ImageSpecView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ImageSpecView: View {
    let label: String
    var systemImage: String? = nil

    var body: some View {
        GroupBox {
            HStack {
                if let systemImage {
                    Image(systemName: systemImage)
                        .imageScale(.medium)
                }
                Text(label)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
        }
        .background(RoundedRectangle(cornerRadius: 6).fill(.background))
    }
}

struct ImageSpecView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageSpecView(label: "ISO 20")

            ImageSpecView(label: "\u{0192}1.8")

            ImageSpecView(label: "1/2500 s", systemImage: "camera.aperture")
        }
        .scenePadding()
    }
}
