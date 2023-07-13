//
//  InspectorItem.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI

struct InspectorItem: View, Identifiable {
    var id: String = UUID().uuidString
    var label: String? = nil

    @ViewBuilder let content: any View

    // @State private var isExpanded: Bool = true

    var body: some View {
        // Section(isExpanded: $isExpanded) {
        Section {
            // Might be a performance cost?
            AnyView(content)
        } header: {
            if let label {
                Text(label)
            }
        }
    }
}



struct InspectorItem_Previews: PreviewProvider {
    static var previews: some View {
        InspectorItem {
            Text("testing")
        }
    }
}
