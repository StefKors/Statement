import SwiftUI
import CoreGraphics
import Accelerate

#if canImport(UIKit)
import UIKit
public typealias HistogramImage = UIImage
#endif

#if canImport(AppKit)
import AppKit
public typealias HistogramImage = NSImage
#endif


/// A SwiftUI Image Histogram View (for RGB channels)
public struct HistogramView: View {

    /// The image from which the histogram will be calculated
    public let image: CGImage

    /// The opacity of each channel layer. Default is `1`
    public let channelOpacity: CGFloat

    /// The blend mode for the channel layers. Default is `.screen`
    public let blendMode: BlendMode

    /// The scale of each layer. Default is `1`
    public let scale: CGFloat

    public init(
        image: HistogramImage,
        channelOpacity: CGFloat = 1,
        blendMode: BlendMode = .screen,
        scale: CGFloat = 1,
        red: Color = .red,
        green: Color = .green,
        blue: Color = .blue
    ) {
        self.image          = image.cgImage!
        self.channelOpacity = channelOpacity
        self.blendMode      = blendMode
        self.scale          = scale
        self.redColor = red
        self.greenColor = green
        self.blueColor = blue
    }

    public let redColor: Color
    public let greenColor: Color
    public let blueColor: Color

    private let lineWidth: CGFloat = 1

    public var body: some View {
        if let data = image.histogram() {
            ZStack {
                Group {
                    ZStack {
                        HistogramChannel(data: data.red, scale: scale)
                            .stroke(redColor, lineWidth: lineWidth)
                        HistogramChannel(data: data.red, scale: scale)
                            .fill(redColor.opacity(0.3))
                    }
                    ZStack {
                        HistogramChannel(data: data.green, scale: scale)
                            .stroke(greenColor, lineWidth: lineWidth)
                        HistogramChannel(data: data.green, scale: scale)
                            .fill(greenColor.opacity(0.3))
                    }
                    ZStack {
                        HistogramChannel(data: data.blue, scale: scale)
                            .stroke(blueColor, lineWidth: lineWidth)
                        HistogramChannel(data: data.blue, scale: scale)
                            .fill(blueColor.opacity(0.3))
                    }
                }
                .opacity(channelOpacity)
                .blendMode(blendMode)
            }
            .id(image)
            .drawingGroup()
        }
    }
}



