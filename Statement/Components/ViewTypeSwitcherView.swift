//
//  ViewTypeSwitcherView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct ViewTypeSwitcherView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        GroupBox {
            Picker("What is your favorite color?", selection: $model.viewPreference) {
                Image(systemName: "square.filled.and.line.vertical.and.square")
                    .tag(ViewType.sideBySide)

                Image(systemName: "square.2.layers.3d.top.filled")
                    .tag(ViewType.stacked)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
        .background(RoundedRectangle(cornerRadius: 6).fill(.background))
        .frame(maxWidth: 100)
    }
}

struct ViewTypeSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ViewTypeSwitcherView()
    }
}
