//
//  EditedImageView.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI
import SwiftUICoreImage

extension NSImage {
    /// Generates a CIImage for this NSImage.
    /// - Returns: A CIImage optional.
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        let ci = CIImage(bitmapImageRep: bitmap)
        return ci
    }

    /// Generates an NSImage from a CIImage.
    /// - Parameter ciImage: The CIImage
    /// - Returns: An NSImage optional.
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
}

struct EditedImageView: View {
    var ciImage: CIImage?

    var body: some View {
        VStack {
            if let ciImage {
                Image(ciImage: ciImage
                    .sepiaTone(intensity: 2.0)
                    // .recropping { image in
                    //     image
                    //         .clampedToExtent(active: false)
                    //         .gaussianBlur(radius: 25.0)
                    // }
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .id("edited-image")
            }
        }
        .makeInspector {
            InspectorItem {
                Text("test1")
            }
            InspectorItem {
                Text("test2")
            }
            InspectorItem {
                Text("test3")
            }
            InspectorItem {
                Text("test4")
            }
        }
    }
}
struct EditedImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditedImageView()
    }
}
