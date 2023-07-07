//
//  InspectorRenderer.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI

struct InspectorRenderer: View {
    @EnvironmentObject private var inspectorState: InspectorModel
    
    var body: some View {
        Form {
            ForEach(inspectorState.items) { item in
                item
            }
        }
        .formStyle(.grouped)
    }
}

struct InspectorRenderer_Previews: PreviewProvider {
    static var previews: some View {
        InspectorRenderer()
    }
}
