//
//  Color.swift
//  Commitment
//
//  Created by Stef Kors on 28/02/2023.
//

import SwiftUI
import AppKit

extension Color {

    @available(macOS 10.10, *)
    static var labelColor: Color {
        Color(nsColor: .labelColor)
    }

    @available(macOS 10.10, *)
    static var secondaryLabelColor: Color {
        Color(nsColor: .secondaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var tertiaryLabelColor: Color {
        Color(nsColor: .tertiaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var quaternaryLabelColor: Color {
        Color(nsColor: .quaternaryLabelColor)
    }

    @available(macOS 10.10, *)
    static var linkColor: Color {
        Color(nsColor: .linkColor)
    }

    @available(macOS 10.10, *)
    static var placeholderTextColor: Color {
        Color(nsColor: .placeholderTextColor)
    }

    static var windowFrameTextColor: Color {
        Color(nsColor: .windowFrameTextColor)
    }

    static var selectedMenuItemTextColor: Color {
        Color(nsColor: .selectedMenuItemTextColor)
    }

    static var alternateSelectedControlTextColor: Color {
        Color(nsColor: .alternateSelectedControlTextColor)
    }

    static var headerTextColor: Color {
        Color(nsColor: .headerTextColor)
    }

    @available(macOS 10.14, *)
    static var separatorColor: Color {
        Color(nsColor: .separatorColor)
    }

    static var gridColor: Color {
        Color(nsColor: .gridColor)
    }

    static var windowBackgroundColor: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    @available(macOS 10.8, *)
    static var underPageBackgroundColor: Color {
        Color(nsColor: .underPageBackgroundColor)
    }

    static var controlBackgroundColor: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var selectedContentBackgroundColor: Color {
        Color(nsColor: .selectedContentBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedContentBackgroundColor: Color {
        Color(nsColor: .unemphasizedSelectedContentBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var alternatingContentBackgroundColors: [Color] {
        return NSColor.alternatingContentBackgroundColors.map { color in
            Color(nsColor: color)
        }
    }

    @available(macOS 10.13, *)
    static var findHighlightColor: Color {
        Color(nsColor: .findHighlightColor)
    }

    static var textColor: Color {
        Color(nsColor: .textColor)
    }

    static var textBackgroundColor: Color {
        Color(nsColor: .textBackgroundColor)
    }

    static var selectedTextColor: Color {
        Color(nsColor: .selectedTextColor)
    }

    static var selectedTextBackgroundColor: Color {
        Color(nsColor: .selectedTextBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedTextBackgroundColor: Color {
        Color(nsColor: .unemphasizedSelectedTextBackgroundColor)
    }

    @available(macOS 10.14, *)
    static var unemphasizedSelectedTextColor: Color {
        Color(nsColor: .unemphasizedSelectedTextColor)
    }

    static var controlColor: Color {
        Color(nsColor: .controlColor)
    }

    static var controlTextColor: Color {
        Color(nsColor: .controlTextColor)
    }

    static var selectedControlColor: Color {
        Color(nsColor: .selectedControlColor)
    }

    static var selectedControlTextColor: Color {
        Color(nsColor: .selectedControlTextColor)
    }

    static var disabledControlTextColor: Color {
        Color(nsColor: .disabledControlTextColor)
    }

    static var keyboardFocusIndicatorColor: Color {
        Color(nsColor: .keyboardFocusIndicatorColor)
    }

    @available(macOS 10.12.2, *)
    static var scrubberTexturedBackground: Color {
        Color(nsColor: .scrubberTexturedBackground)
    }

    @available(macOS 10.10, *)
    static var systemRed: Color {
        Color(nsColor: .systemRed)
    }

    @available(macOS 10.10, *)
    static var systemGreen: Color {
        Color(nsColor: .systemGreen)
    }

    @available(macOS 10.10, *)
    static var systemBlue: Color {
        Color(nsColor: .systemBlue)
    }

    @available(macOS 10.10, *)
    static var systemOrange: Color {
        Color(nsColor: .systemOrange)
    }

    @available(macOS 10.10, *)
    static var systemYellow: Color {
        Color(nsColor: .systemYellow)
    }

    @available(macOS 10.10, *)
    static var systemBrown: Color {
        Color(nsColor: .systemBrown)
    }

    @available(macOS 10.10, *)
    static var systemPink: Color {
        Color(nsColor: .systemPink)
    }

    @available(macOS 10.10, *)
    static var systemPurple: Color {
        Color(nsColor: .systemPurple)
    }

    @available(macOS 10.10, *)
    static var systemGray: Color {
        Color(nsColor: .systemGray)
    }

    @available(macOS 10.12, *)
    static var systemTeal: Color {
        Color(nsColor: .systemTeal)
    }

    @available(macOS 10.15, *)
    static var systemIndigo: Color {
        Color(nsColor: .systemIndigo)
    }

    @available(macOS 10.12, *)
    static var systemMint: Color {
        Color(nsColor: .systemMint)
    }

    @available(macOS 12.0, *)
    static var systemCyan: Color {
        Color(nsColor: .systemCyan)
    }

    /// The user's current accent color preference. Users set the accent color in the General pane of system preferences. Do not make assumptions about the color space associated with this color. Crudely bridged to SwiftUI See [controlAccentColor](https://developer.apple.com/documentation/appkit/nscolor/3000782-controlaccentcolor)
    /** A dynamic color that reflects the user's current preferred accent color. This color automatically updates when the accent color preference changes. Do not make assumptions about the color space of this color, which may change across releases. */
    @available(macOS 10.14, *)
    static var controlAccentColor: Color {
        Color(nsColor: .controlAccentColor)
    }

    static var highlightColor: Color {
        Color(nsColor: .highlightColor)
    }

    static var shadowColor: Color {
        Color(nsColor: .shadowColor)
    }
}
