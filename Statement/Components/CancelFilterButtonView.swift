//
//  CancelFilterButtonView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct CancelFilterButtonView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        Button("Remove Filter") {
            print("todo")
        }
    }
}

struct CancelFilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CancelFilterButtonView()
    }
}
