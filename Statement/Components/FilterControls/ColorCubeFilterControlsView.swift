//
//  ColorCubeFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct ColorCubeFilterControlsView: View {
    @EnvironmentObject private var model: ColorCubeModel

    var image: EditorImage? = nil

    private let step: Float.Stride = 0.1

    var body: some View {
        Section {
            Toggle("Show/Hide", isOn: $model.showFilter)
            Slider(
                value: $model.brightnessAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Brightness")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }

            Slider(
                value: $model.saturationAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Saturation")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }

            Slider(
                value: $model.destCenterHueAngle,
                in: 0...1,
                step: step
            ) {
                Text("Hue Angle")
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
            Text("ColorCube Filter")
        }        
    }
}

struct ColorCubeFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCubeFilterControlsView(image: nil)
    }
}
