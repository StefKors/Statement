//
//  ButtonStyleRegular.swift
//  Commitment
//
//  Created by Stef Kors on 07/05/2023.
//

import SwiftUI

struct RegularButtonStyleModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    @State var isHovering: Bool = false

    static let light1 = Color(red: 0.901961, green: 0.901961, blue: 0.905882)
    static let light2 = Color(red: 0.780392, green: 0.780392, blue: 0.784314)
    static let lightF1 = Color(red: 1, green: 1, blue: 1)
    static let lightF2 = Color(red: 0.952941, green: 0.956863, blue: 0.964706)
    static let lightShadow = Color(red: 0, green: 0, blue: 0, opacity: 0.08)

    static let dark1 = Color(red: 0.274532, green: 0.274492, blue: 0.286276)
    static let dark2 = Color(red: 0.188235, green: 0.188235, blue: 0.188235)
    static let darkF1 = Color(red: 0.180423, green: 0.180368, blue: 0.196081)
    static let darkF2 = Color(red: 0.141199, green: 0.141159, blue: 0.152943)
    static let darkShadow = Color(red: 0.0470743, green: 0.0470467, blue: 0.0549031)

    var hoverOutline: Color {
        if isHovering {
            return colorShadow
        } else {
            return Color.clear
        }
    }

    let cornerRadius = 5.0

    var color1: Color {
        if colorScheme == .light {
            return RegularButtonStyleModifier.light1
        } else {
            return RegularButtonStyleModifier.dark1
        }
    }

    var color2: Color {
        if colorScheme == .light {
            return RegularButtonStyleModifier.light2
        } else {
            return RegularButtonStyleModifier.dark2
        }
    }

    var colorF1: Color {
        if colorScheme == .light {
            return RegularButtonStyleModifier.lightF1
        } else {
            return RegularButtonStyleModifier.darkF1
        }
    }

    var colorF2: Color {
        if colorScheme == .light {
            return RegularButtonStyleModifier.lightF2
        } else {
            return RegularButtonStyleModifier.darkF2
        }
    }

    var colorShadow: Color {
        if colorScheme == .light {
            return RegularButtonStyleModifier.lightShadow
        } else {
            return RegularButtonStyleModifier.darkShadow
        }
    }

    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(hoverOutline, lineWidth: 3))
                    .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(hoverOutline.opacity(0.2), lineWidth: 6))
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            gradient:
                                Gradient(colors: [
                                    colorF1,
                                    colorF2
                                ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: cornerRadius,
                            style: .continuous
                        ).stroke(
                            LinearGradient(
                                gradient:
                                    Gradient(colors: [
                                        color1,
                                        color2
                                    ]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                    )
            }
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .shadow(color: colorShadow, radius: 2, x: 0, y: 1)
            )

            .onHover(perform: { hoverState in
                withAnimation(.easeIn(duration: 0.15)) {
                    isHovering = hoverState
                }
            })
    }
}

extension View {
    func regularButtonStyle() -> some View {
        modifier(RegularButtonStyleModifier())
    }
}

struct RegularButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
        }
        .regularButtonStyle()
        .allowsHitTesting(isEnabled)

    }
}

extension ButtonStyle where Self == RegularButtonStyle {
    /// Custom button style
    static var regularButtonStyle: RegularButtonStyle { .init() }
}

struct ButtonStyleRegular_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Click Here! (Light)", action: {})
                .buttonStyle(.regularButtonStyle)
                .padding()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Default")

            Button("Click Here! (Dark)", action: {})
                .buttonStyle(.regularButtonStyle)
                .padding()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Default")

            Button("Click Here! (Disabled)", action: {})
                .buttonStyle(.regularButtonStyle)
                .padding()
                .disabled(true)
                .previewDisplayName("Disabled")
        }
    }
}
