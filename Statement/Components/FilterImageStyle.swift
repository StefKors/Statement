//
//  FilterImageStyle.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI

struct FilterImageStyle: ViewModifier {
    let isSelected: Bool

    private var color: Color {
        if isSelected {
            return Color.accentColor
        }

        return Color.clear

    }

    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 50, height: 50)
            .cornerRadius(6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(color, lineWidth: 3)
            }
    }
}

extension View {
    func filterImageStyle(_ isSelected: Bool) -> some View {
        modifier(FilterImageStyle(isSelected: isSelected))
    }
}
