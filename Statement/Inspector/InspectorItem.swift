//
//  InspectorItem.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI

struct InspectorItem: View, Identifiable {
    @ViewBuilder let content: any View

    var id: String = UUID().uuidString

    var body: some View {
        Section {
            // Might be a performance cost?
            AnyView(content)
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
