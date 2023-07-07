//
//  SepiaFilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct SepiaFilterControlsView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var filterModel: SepiaModel

    var image: EditorImage

    private let step: Float.Stride = 0.1
    @State private var showFilter: Bool = false
    var body: some View {
        Section {
            Slider(
                value: $filterModel.intensityAdjustment,
                in: 0...1,
                step: step
            ) {
                Text("Intensity")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("1")
            }
        } header: {
            Text("Sepia Filter")
        }
    }
}

struct SepiaFilterControlsView_Previews: PreviewProvider {
    static var previews: some View {
        SepiaFilterControlsView(image: .preview)
    }
}
