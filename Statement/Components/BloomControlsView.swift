//
//  BloomControlsView.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI

struct BloomControlsView: View {
    @Binding var radius: CGFloat
    let radiusRange: ClosedRange<CGFloat>
    @Binding var intensity: CGFloat
    let intensityRange: ClosedRange<CGFloat>
    var body: some View {
        Slider(
            value: $radius,
            in: radiusRange
        ) {
            Text("Radius")
        }
        Slider(
            value: $intensity,
            in: intensityRange
        ) {
            Text("Intensity")
        }
    }
}

// #Preview {
//     BloomControlsView()
// }
