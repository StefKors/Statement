//
//  AdjustableColorCubeFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct AdjustableColorCubeFilterControlsView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var filterModel: AdjustableColorCubeModel

    var image: EditorImage

    private let step: Float.Stride = 0.1

    var body: some View {
        Section {
            Slider(
                value: $filterModel.brightnessAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Brightness")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
            .onChange(of: filterModel.brightnessAdjustment) { _ in
                model.enabledFilter = filterModel.type
                model.filteredImageState = filterModel.processImage(image)
            }

            Slider(
                value: $filterModel.saturationAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Saturation")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
            .onChange(of: filterModel.saturationAdjustment) { _ in
                model.enabledFilter = filterModel.type
                model.filteredImageState = filterModel.processImage(image)
            }

            Slider(
                value: $filterModel.destCenterHueAngle,
                in: 0...1,
                step: step
            ) {
                Text("Hue Angle")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
            .onChange(of: filterModel.destCenterHueAngle) { _ in
                model.enabledFilter = filterModel.type
                model.filteredImageState = filterModel.processImage(image)
            }
        } header: {
            Text("Adjustable ColorCube Filter")
        }
    }
}

struct AdjustableColorCubeFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustableColorCubeFilterControlsView(image: .preview)
    }
}
