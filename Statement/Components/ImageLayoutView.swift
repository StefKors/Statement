//
//  ImageLayoutView.swift
//  Statement
//
//  Created by Stef Kors on 13/07/2023.
//

import SwiftUI

struct ImageLayoutView: View {
    let ciImage: CIImage
    let viewPreference: ViewType

    var body: some View {
        switch viewPreference {
        case .sideBySide:
            SideBySideView {
                EditedImageView(ciImage: ciImage)
            }
        case .stacked:
            StackedView {
                EditedImageView(ciImage: ciImage)
            }
        }
    }
}

// #Preview {
//     ImageLayoutView()
// }
