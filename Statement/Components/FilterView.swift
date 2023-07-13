//
//  FilterView.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI
import SwiftUICoreImage

struct FilterView: View {
    let filter: CubeData
    let isSelected: Bool

    @Environment(\.currentImage) private var currentImage

    var body: some View {
        HStack(alignment: .center) {
            Image(ciImage: currentImage
                .transformed(by: CGAffineTransform(scaleX: 0.05, y: 0.05))
                .colorCubeWithColorSpace(
                    cubeDimension: filter.dimension,
                    cubeData: filter.data,
                    extrapolate: filter.extrapolate,
                    colorSpace: filter.colorSpace,
                    active: true
                )
            )
            .resizable()
            .filterImageStyle(isSelected)

            Text(filter.name)
                .font(.caption2)
                .foregroundStyle(isSelected ? .primary : .secondary)

            Spacer()
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FilterView(filter: CubeData(name: "kodak"), isSelected: false)
            FilterView(filter: CubeData(name: "green"), isSelected: true)
            FilterView(filter: CubeData(name: "summer"), isSelected: false)
        }
        .scenePadding()
    }
}
