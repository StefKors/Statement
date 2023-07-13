//
//  InspectorRenderer.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI

struct InspectorRenderer: View {
    @EnvironmentObject private var inspector: InspectorModel

    var body: some View {
        InspectorItem(label: "Sepia Effect") {
            ImageSlider(value: $inspector.sepiaToneIntensity, range: 0...1)
        }
        // InspectorItem(label: "Comic Effect") {
        //     Toggle("Enabled", isOn: $inspector.enableComicEffect)
        // }
        // InspectorItem(label: "Hue Adjust Effect \(inspector.hueAdjustAngle.description)") {
        //     HueRangeSlider(value: $inspector.hueAdjustAngle, range: 0...1, step: 0.05)
        // }
        InspectorItem(label: "Vibrance") {
            VibranceAmountSlider(value: $inspector.vibranceAmount, range: 0...1)
        }

        // InspectorItem(label: "Bloom") {
        //     BloomControlsView(
        //         radius: $inspector.bloomRadius,
        //         radiusRange: 0...100,
        //         intensity: $inspector.bloomIntensity,
        //         intensityRange: 0...1
        //     )
        // }

        InspectorItem(label: "Filters") {
            FilterControlsView(
                filters: inspector.filters,
                selected: $inspector.selectedFilter
            )
        }

    }
}

struct InspectorRenderer_Previews: PreviewProvider {
    static var previews: some View {
        InspectorRenderer()
    }
}
