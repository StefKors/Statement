//
//  Exif.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

/// based on: https://github.com/hipposan/Oslo/blob/3a15ab4f0ec5209723b17ed9501f26bcf6ab526c/Oslo/OperationService.swift#L84
struct Exif {
    var aperture:  CGFloat? = nil
    var brightness:  CGFloat? = nil
    var colorSpace:  Int? = nil
    var createTime:  Date? = nil
    var exposureBias:  Int? = nil
    var exposureMode:  Int? = nil
    var exposureProgram:  Int? = nil
    var exposureTime:  CGFloat? = nil
    var fstop:  CGFloat? = nil
    var flashValue:  Int? = nil
    var focalLenIn35mmFilm:  Int? = nil
    var focalLength:  CGFloat? = nil
    var ISOSpeedRatings:  [Int]? = nil
    var device: String? = nil
    var deviceDescription: String? = nil
    var lensMake:  String? = nil
    var lensModel:  String? = nil
    var lensSpecification:  [CGFloat]? = nil
    var meteringMode:  Int? = nil
    var offsetTime:  String? = nil
    var offsetTimeDigitized:  String? = nil
    var offsetTimeOriginal:  String? = nil
    var width:  Int? = nil
    var height:  Int? = nil
    var sceneCaptureType:  Int? = nil
    var sceneType:  Int? = nil
    var sensingMethod:  Int? = nil
    var shutterSpeedValue:  CGFloat? = nil
    var whiteBalance:  Int? = nil
    var location: MapLocation? = nil

    init() { }

    init(data: Data) {
        guard let cgImage = CGImageSourceCreateWithData(data as CFData, nil),
              let metaDict: NSDictionary = CGImageSourceCopyPropertiesAtIndex(cgImage, 0, nil) else { return }

        let data: NSDictionary = metaDict.object(forKey: kCGImagePropertyExifDictionary) as! NSDictionary
        print(data)
        self.aperture = data["ApertureValue"] as? CGFloat
        self.brightness = data["BrightnessValue"] as? CGFloat
        self.colorSpace = data["ColorSpace"] as? Int
        self.createTime = data["DateTimeOriginal"] as? Date
        self.exposureBias = data["ExposureBiasValue"] as? Int
        self.exposureMode = data["ExposureMode"] as? Int
        self.exposureProgram = data["ExposureProgram"] as? Int
        self.exposureTime = data["ExposureTime"] as? CGFloat
        self.fstop = data["FNumber"] as? CGFloat
        self.flashValue = data["Flash"] as? Int
        self.focalLenIn35mmFilm = data["FocalLenIn35mmFilm"] as? Int
        self.focalLength = data["FocalLength"] as? CGFloat
        self.ISOSpeedRatings = data["ISOSpeedRatings"] as? [Int]
        self.lensMake = data["LensMake"] as? String
        self.lensModel = data["LensModel"] as? String
        if let lensModel {
            let parts = lensModel.components(separatedBy: .whitespaces)
            if let splitIndex = parts.firstIndex(where: { str in
                return str == "front" || str == "back"
            }) {
                let trimmed = parts.prefix(splitIndex)
                self.device = trimmed.joined(separator: " ")
                let description = parts.suffix(splitIndex)
                self.deviceDescription = description.joined(separator: " ")
            }
        }
        self.lensSpecification = data["LensSpecification"] as? [CGFloat]
        self.meteringMode = data["MeteringMode"] as? Int
        self.offsetTime = data["OffsetTime"] as? String
        self.offsetTimeDigitized = data["OffsetTimeDigitized"] as? String
        self.offsetTimeOriginal = data["OffsetTimeOriginal"] as? String
        self.width = data["PixelXDimension"] as? Int
        self.height = data["PixelYDimension"] as? Int
        self.sceneCaptureType = data["SceneCaptureType"] as? Int
        self.sceneType = data["SceneType"] as? Int
        self.sensingMethod = data["SensingMethod"] as? Int
        self.shutterSpeedValue = data["ShutterSpeedValue"] as? CGFloat
        self.whiteBalance = data["WhiteBalance"] as? Int

        let gpsData: NSDictionary = metaDict.object(forKey: kCGImagePropertyGPSDictionary) as! NSDictionary
        if let latitude = gpsData["Latitude"] as? Double, let longitude = gpsData["Longitude"] as? Double {
            self.location = MapLocation(latitude: latitude, longitude: longitude)
        }
    }
}
