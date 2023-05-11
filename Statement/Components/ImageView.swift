//
//  ImageView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ImageView: View {
    let imageState: ImageState

    var body: some View {
        switch imageState {
        case .success(let image):
            image.image.resizable()
                .id(image.id)
        case .loading(let progress):
            ProgressView(progress)
                .progressViewStyle(.linear)
                .frame(maxWidth: 150)
                .padding(4)
        case .empty:
            EmptyView()
        case .failure(let error):
            VStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                Text(error.localizedDescription)
            }
        }
    }
}

enum PreviewError: Error {
    case exampleError
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ImageView(imageState: .success(EditorImage(image: Image(systemName: "photo"), data: Data(), exif: Exif(data: Data()))))
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 100, height: 100)

            ImageView(imageState: .loading(Progress(totalUnitCount: 20)))
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 100, height: 100)

            ImageView(imageState: .failure(PreviewError.exampleError))
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 100, height: 100)

            ImageView(imageState: .empty)
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 100, height: 100)

        }
        .frame(width: 300)
        .scenePadding()
    }
}
