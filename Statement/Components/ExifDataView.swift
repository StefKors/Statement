//
//  ExifDataView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import MapKit

struct ExifDataView: View {
    let exif: Exif
    var body: some View {
        VStack(alignment: .leading) {
            if let device = exif.device, let maker = exif.lensMake {
                Text([maker, device].joined(separator: " "))
                    .foregroundStyle(.primary)
                Divider()
            }

            if let deviceDescription = exif.deviceDescription {
                Text(deviceDescription.trimmingCharacters(in: .whitespaces).capitalizedSentence)
            }

            HStack {
                if let width = exif.width, let height = exif.height {
                    ImageSpecView(label: "\(width) \u{00d7} \(height)", systemImage: "crop")
                }
            }

            if exif.focalLenIn35mmFilm != nil {
                LazyHGrid(rows: [GridItem(.flexible())], alignment: .center) {
                    if let iso = exif.ISOSpeedRatings?.first {
                        Spacer()
                        Text("ISO \(iso)")
                        Spacer()
                        Divider()
                    }

                    if let focalLength = exif.focalLenIn35mmFilm {
                        Spacer()
                        Text("\(focalLength) mm")
                        Spacer()
                        Divider()
                    }
                    if let exposureBias = exif.exposureBias {
                        Spacer()
                        Text("\(exposureBias) ev")
                        Spacer()
                        Divider()
                    }
                    if let aperture = exif.aperture?.decimals(2) {
                        Spacer()
                        Text("\u{0192}\(aperture)")
                        Spacer()
                        Divider()
                    }
                    if let rationale = exif.exposureTime?.toExposureRational() {
                        Spacer()
                        Text("\(rationale) s")
                        Spacer()
                    }
                }
                .padding(.bottom, 4)
                .frame(maxHeight: 12)
            }

            if let location = exif.location {
                MapPinView(location: location)
            }
        }
        .foregroundStyle(.secondary)
    }
}

extension String {
    fileprivate var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}

extension CGFloat {
    func decimals(_ nbr: Int) -> String {
        String(format: "%.\(nbr.description)f", self)
    }

    /// Converts exposure time to exposure value. For example: 0.0166666 to 1/60
    fileprivate func toExposureRational() -> String? {
        let rational = Rational.init(approximationOf: self)
        guard rational.num < rational.den else { return nil }
        let exposureString = (String(describing: rational.num) + "/" + String(describing: rational.den))
        return exposureString
    }
}

struct ExifDataView_Previews: PreviewProvider {
    static var previews: some View {
        ExifDataView(exif: Exif())
    }
}
