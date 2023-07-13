//
//  GradientSliderView.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI

struct GradientSliderView: View {
    @Binding var value: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    let range: [Color] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1].map { val in
        Color(hue: val, saturation: 1, brightness: 1)
    }

    var scrubberColor: Color {
        colorScheme == .dark ? Color(nsColor: NSColor.lightGray) : Color.textBackgroundColor
    }

    @State private var location: CGFloat = .zero


    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(colors: range, startPoint: .leading, endPoint: .trailing))
                    .padding(2)
                    .frame(height: 10)

                RoundedRectangle(cornerRadius: 6)
                    .fill(scrubberColor)
                // .fill(Color(nsColor: NSColor(.controlTextColor)))
                    .shadow(radius: 3)
                    .frame(width: 8, height: 20)
                    .offset(x: location.clamp(0, geometry.size.width))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.location = value.location.x

                                let number = 0
                                let degree = 180
                                self.value = 180 * .pi / 180

                                // let zeroToOneValue = (1/geometry.size.width) * value.location.x
                                // let degrees = zeroToOneValue * 360
                                // let radians = deg2rad(degrees)
                                // self.value = radians
                            }
                    )

            }
        }
        .frame(height: 40)
    }

    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
}

// #Preview {
//     GradientSliderView()
// }
