//
//  VibranceAmountSlider.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI

struct VibranceAmountSlider: View {
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>

    var body: some View {
        Slider(
            value: $value,
            in: range
        ) {
            Text("Amount")
        }
    }
}

// #Preview {
//     VibranceAmountSlider()
// }
