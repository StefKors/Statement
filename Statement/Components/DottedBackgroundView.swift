//
//  DottedBackgroundView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

extension View {
    func dottedBackgroundPattern() -> some View {
        modifier(DottedBackgroundModifier())
    }
}

struct DottedBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DottedBackgroundView().cornerRadius(6))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

struct DottedBackgroundView: View {

    var body: some View {
        VStack {
            Image("dot")
                .resizable(resizingMode: .tile)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.quaternary.opacity(0.8), .clear)
                .imageScale(.small)
        }
        .background(.background)
    }
}

struct DottedBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        DottedBackgroundView()
            .frame(width: 300, height: 300, alignment: .center)
    }
}
