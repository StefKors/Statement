//
//  SepiaModel.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class SepiaModel: BaseFilterModel, ObservableObject {
    @Published var intensityAdjustment: Float = 1

    override func applyFilter(_ inputImage: CIImage) -> CIImage? {
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = inputImage
        currentFilter.intensity = intensityAdjustment
        return currentFilter.outputImage
    }
}
