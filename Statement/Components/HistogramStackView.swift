//
//  HistogramStackView.swift
//  Statement
//
//  Created by Stef Kors on 13/07/2023.
//

import SwiftUI

struct HistogramStackView: View {
    let image: EditorImage
    @EnvironmentObject private var inspector: InspectorModel

    var editedImage: NSImage {
        let ciImage = inspector.makeEditedImage(ciImage: image.ciImage)
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }

    var body: some View {
        VStack {
            HistogramView(
                image: editedImage,
                channelOpacity: 0.5,
                blendMode: .multiply,
                red: .red,
                green: .green,
                blue: .blue
            )

            HistogramView(
                image: image.nsImage,
                channelOpacity: 0.5,
                blendMode: .multiply,
                red: .red,
                green: .green,
                blue: .blue
            )
        }
        .frame(height: 200)
    }
}

// #Preview {
//     HistogramStackView()
// }
