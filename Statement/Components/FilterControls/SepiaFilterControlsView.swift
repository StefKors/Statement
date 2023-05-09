//
//  SepiaFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct SepiaFilterControlsView: View {
    @EnvironmentObject private var model: SepiaModel

    var image: EditorImage? = nil

    private let step: Float.Stride = 0.1

    var body: some View {
        Section {
            Toggle("Show/Hide", isOn: $model.showFilter)
            Slider(
                value: $model.intensityAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Intensity")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }

            Button("Apply Filter") {
                guard let image else { return }
                model.processImage(image)
            }
            .disabled(image == nil)
        } header: {
            Text("Sepia Filter")
        }
    }
}

struct SepiaFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        SepiaFilterControlsView(image: nil)
    }
}
