//
//  InspectorModel.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI
import Accelerate
import SwiftUICoreImage

public enum ColorCubeHelperError: Error {
    case incorrectImageSize
    case unableToCreateDataProvider
    case unableToGetBitmpaDataBuffer
}

// from: https://stackoverflow.com/a/28288340/3199999
extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}


struct CubeData: Identifiable, Equatable {
    let id: String
    let name: String
    let data: Data
    let colorSpace: CGColorSpace
    let dimension: Int
    let extrapolate: Bool = true

    init(name: String, dimension: Int = 64) {
        self.id = name
        self.name = name.replacingOccurrences(of: "_", with: " ").firstUppercased
        self.dimension = dimension
        let image = Bundle.main.image(forResource: name)
        let cgImage = image!.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        self.colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
        self.data = try! CubeData.createColorCubeData(inputImage: cgImage, cubeDimension: dimension)
    }

    static func createColorCubeData(inputImage cgImage: CGImage, cubeDimension: Int) throws -> Data {

        let pixels = cgImage.width * cgImage.height
        let channels = 4

        // If the number of pixels doesn't match what's needed for the supplied cube dimension, abort.
        guard pixels == cubeDimension * cubeDimension * cubeDimension else {
            throw ColorCubeHelperError.incorrectImageSize
        }

        // We don't need a sizeof() because uint_8t is explicitly 1 byte.
        let memSize = pixels * channels

        let inBitmapData = cgImage.dataProvider!.data
        guard let inBuffer = CFDataGetBytePtr(inBitmapData) else {
            throw ColorCubeHelperError.unableToGetBitmpaDataBuffer
        }

        // Calculate the size of the float buffer and allocate it.
        let floatSize = memSize * MemoryLayout<Float>.size
        let finalBuffer = unsafeBitCast(malloc(floatSize), to:UnsafeMutablePointer<Float>.self)

        // Convert the uint_8t to float. Note: a uint of 255 will convert to 255.0f.
        vDSP_vfltu8(inBuffer, 1, finalBuffer, 1, UInt(memSize))

        // Divide each float by 255.0 to get the 0-1 range we are looking for.
        var divisor = Float(255.0)
        vDSP_vsdiv(finalBuffer, 1, &divisor, finalBuffer, 1, UInt(memSize))
        // Don't copy the bytes, just have the NSData take ownership of the buffer.
        let cubeData = NSData(bytesNoCopy: finalBuffer, length: floatSize, freeWhenDone: true)

        return cubeData as Data
    }
}

class InspectorModel: ObservableObject {
    @Published var sepiaToneIntensity: CGFloat = 0
    @Published var enableComicEffect: Bool = false
    @Published var hueAdjustAngle: CGFloat = 0
    @Published var vibranceAmount: CGFloat = 0
    @Published var bloomRadius: CGFloat = 0
    @Published var bloomIntensity: CGFloat = 0
    @Published var selectedFilter: CubeData

    init() {
        self.selectedFilter = filters.first!
    }

    func makeEditedImage(ciImage: CIImage) -> CIImage {
        ciImage
            .sepiaTone(intensity: Float(self.sepiaToneIntensity))
        // .comicEffect(active: self.enableComicEffect)
            .vibrance(amount: Float(self.vibranceAmount))
            .colorCubeWithColorSpace(
                cubeDimension: self.selectedFilter.dimension,
                cubeData: self.selectedFilter.data,
                extrapolate: self.selectedFilter.extrapolate,
                colorSpace: self.selectedFilter.colorSpace
            )
        // .recropping { image in
        //     image
        //         .clampedToExtent(active: false)
        //         .bloom(
        //             radius: Float(self.bloomRadius),
        //             intensity: Float(self.bloomIntensity)
        //         )
        // }
    }

    // converted wrong luts with: https://www.color.io/free-online-lut-converter
    let filters: [CubeData] = [
        CubeData(name: "neutral"),
        CubeData(name: "kodak"),
        CubeData(name: "latte"),
        CubeData(name: "green"),
        CubeData(name: "summer"),
        CubeData(name: "americano"),
        CubeData(name: "gloss"),
        CubeData(name: "contrast"),
        CubeData(name: "bright"),
        CubeData(name: "spring"),
        CubeData(name: "dew"),
        CubeData(name: "basic"),
        CubeData(name: "infrared"),
        CubeData(name: "infrared_alt"),
        CubeData(name: "greyscale"),
        CubeData(name: "yellow"),
        CubeData(name:"agfa_advantix_100"),
        CubeData(name:"agfa_advantix_200"),
        CubeData(name:"agfa_advantix_400"),
        CubeData(name:"agfa_agfachrome_ct_precisa_100"),
        CubeData(name:"agfa_agfachrome_ct_precisa_200"),
        CubeData(name:"agfa_agfachrome_rsx2_050"),
        CubeData(name:"agfa_agfachrome_rsx2_100"),
        CubeData(name:"agfa_agfachrome_rsx2_200"),
        CubeData(name:"agfa_agfacolor_futura_100_plus"),
        CubeData(name:"agfa_agfacolor_futura_200_plus"),
        CubeData(name:"agfa_agfacolor_futura_400_plus"),
        CubeData(name:"agfa_agfacolor_futura_ii_100_plus"),
        CubeData(name:"agfa_agfacolor_futura_ii_200_plus"),
        CubeData(name:"agfa_agfacolor_futura_ii_400_plus"),
        CubeData(name:"agfa_agfacolor_hdc_100_plus"),
        CubeData(name:"agfa_agfacolor_hdc_200_plus"),
        CubeData(name:"agfa_agfacolor_hdc_400_plus"),
        CubeData(name:"agfa_agfacolor_optima_ii_100"),
        CubeData(name:"agfa_agfacolor_optima_ii_200"),
        CubeData(name:"agfa_agfacolor_vista_050"),
        CubeData(name:"agfa_agfacolor_vista_100"),
        CubeData(name:"agfa_agfacolor_vista_200"),
        CubeData(name:"agfa_agfacolor_vista_400"),
        CubeData(name:"agfa_agfacolor_vista_800"),
        CubeData(name:"eastman_double_x_neg_12_min"),
        CubeData(name:"eastman_double_x_neg_4_min"),
        CubeData(name:"eastman_double_x_neg_5_min"),
        CubeData(name:"eastman_double_x_neg_6_min"),
        CubeData(name:"fujifilm_f_125"),
        CubeData(name:"fujifilm_f_250"),
        CubeData(name:"fujifilm_f_400"),
        CubeData(name:"fujifilm_fci"),
        CubeData(name:"fujifilm_fp2900z"),
        CubeData(name:"kodak_dscs_3151"),
        CubeData(name:"kodak_dscs_3152"),
        CubeData(name:"kodak_dscs_3153"),
        CubeData(name:"kodak_dscs_3154"),
        CubeData(name:"kodak_dscs_3155"),
        CubeData(name:"kodak_dscs_3156"),
        CubeData(name:"kodak_ektachrome_100"),
        CubeData(name:"kodak_ektachrome_100_plus"),
        CubeData(name:"kodak_ektachrome_320t"),
        CubeData(name:"kodak_ektachrome_400x"),
        CubeData(name:"kodak_ektachrome_64"),
        CubeData(name:"kodak_ektachrome_64t"),
        CubeData(name:"kodak_ektachrome_e100s"),
        CubeData(name:"kodak_gold_100"),
        CubeData(name:"kodak_gold_200"),
        CubeData(name:"kodak_kaf_2001"),
        CubeData(name:"kodak_kaf_3000"),
        CubeData(name:"kodak_kai_0311"),
        CubeData(name:"kodak_kai_0372"),
        CubeData(name:"kodak_kai_1010"),
        CubeData(name:"kodak_kodachrome_200"),
        CubeData(name:"kodak_kodachrome_25"),
        CubeData(name:"kodak_kodachrome_64"),
        CubeData(name:"kodak_max_zoom_800"),
        CubeData(name:"kodak_optura_981111"),
        CubeData(name:"kodak_optura_981111_slrr"),
        CubeData(name:"kodak_optura_981113"),
        CubeData(name:"kodak_optura_981114"),
        CubeData(name:"kodak_porta_400nc"),
        CubeData(name:"kodak_porta_400vc"),
        CubeData(name:"kodak_porta_800"),
        CubeData(name:"kodak_portra_100t"),
        CubeData(name:"kodak_portra_160nc"),
        CubeData(name:"kodak_portra_160vc"),
        CubeData(name:"Canon Cinema 1"),
        CubeData(name:"Canon Cinema 2"),
        CubeData(name:"Canon Cinema 3"),
        CubeData(name:"Canon Cinema 4"),
        CubeData(name:"Canon Cinema 5"),
        CubeData(name:"Canon Cinema 6"),
        CubeData(name:"Canon Cinema 7"),
        CubeData(name:"Canon Cinema 8"),
        CubeData(name:"Canon Cinema 9"),
        CubeData(name:"Canon Cinema 10"),
        CubeData(name:"Canon Cinema 11"),
        CubeData(name:"Canon Cinema 12"),
        CubeData(name:"Canon Cinema 13"),
        CubeData(name:"Canon Cinema 14"),
        CubeData(name:"Canon Cinema 15"),
        CubeData(name:"Canon Cinema 16"),
        CubeData(name:"Canon Cinema 17"),
        CubeData(name:"Canon Cinema 18"),
        CubeData(name:"Canon Cinema 19"),
        CubeData(name:"Canon Cinema 20"),
        CubeData(name:"Canon Cinema 21"),
        CubeData(name:"Canon Cinema 22"),
        CubeData(name:"Canon Cinema 23"),
        CubeData(name:"Canon Cinema 24"),
        CubeData(name:"Canon Cinema 25"),
    ]
}
