//
//  EditedImageView.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI
import SwiftUICoreImage

struct ImageSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    var body: some View {
        Slider(
            value: $value,
            in: range
        ) {
            Text("Intensity")
        }
    }
}

struct EditedImageView: View {
    var ciImage: CIImage?
    @EnvironmentObject private var inspector: InspectorModel

    var body: some View {
        VStack {
            if let ciImage {
                Image(ciImage: ciImage
                    .sepiaTone(intensity: Float(inspector.sepiaToneIntensity))
                    // .comicEffect(active: inspector.enableComicEffect)
                    .vibrance(amount: Float(inspector.vibranceAmount))
                    .colorCubeWithColorSpace(
                        cubeDimension: inspector.selectedFilter.dimension,
                        cubeData: inspector.selectedFilter.data,
                        extrapolate: inspector.selectedFilter.extrapolate,
                        colorSpace: inspector.selectedFilter.colorSpace
                    )
                        // .recropping { image in
                        //     image
                        //         .clampedToExtent(active: false)
                        //         .bloom(
                        //             radius: Float(inspector.bloomRadius),
                        //             intensity: Float(inspector.bloomIntensity)
                        //         )
                        // }
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .id("edited-image")
            }
        }
    }
}
struct EditedImageView_Previews: PreviewProvider {
    static var previews: some View {
        EditedImageView()
    }
}
