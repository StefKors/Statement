//
//  PaperStackView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct PaperView: View {
    private let radius: CGFloat = 4
    var body: some View {
        RoundedRectangle(cornerRadius: radius)
            .strokeBorder(.tertiary.opacity(0.8))
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(.background)
                    .shadow(color: Color.shadowColor.opacity(0.2), radius: 3)
            )
            .overlay(alignment: .top, content: {
                RoundedRectangle(cornerRadius: radius)
                    .fill(.separator)
                    .overlay {
                        RoundedRectangle(cornerRadius: radius)
                            .strokeBorder(.tertiary.opacity(0.2))
                    }
                    .padding(4)
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
            })
            .aspectRatio(CGSize(width: 3.5, height: 4.2), contentMode: .fit)
    }
}

struct PaperStackView: View {
    let hover: Bool

    private let radius: CGFloat = 12

    var rotation: CGFloat {
        hover ? 9 : 5
    }

    var scale: CGFloat {
        hover ? 1.1 : 1
    }

    var body: some View {
        ZStack {
            PaperView()
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
            PaperView()
                .rotationEffect(.degrees(-rotation))
                .scaleEffect(scale)
        }
        .animation(.spring(), value: hover)
        .frame(maxWidth: 100)
        .padding()
    }
}

// struct PaperStackView_Previews: PreviewProvider {
//     static var previews: some View {
//         VStack {
//             PaperStackView(hover: .constant(false))
//                 .padding()
//
//             PaperStackView(hover: .constant(true))
//                 .padding()
//         }
//         .scenePadding()
//     }
// }
