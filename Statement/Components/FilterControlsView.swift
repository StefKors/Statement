//
//  FilterControlsView.swift
//  Statement
//
//  Created by Stef Kors on 12/07/2023.
//

import SwiftUI

struct FilterControlsView: View {
    let filters: [CubeData]
    @Binding var selected: CubeData

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                ForEach(filters) { filter in
                    FilterView(filter: filter, isSelected: filter == selected)
                        .padding(2)
                        .clipShape(Rectangle())
                        .onTapGesture {
                            if selected != filter {
                                selected = filter
                            }
                        }
                }
            }
        }
        .frame(height: 200)
    }
}

// #Preview {
//     FilterControlsView()
// }
