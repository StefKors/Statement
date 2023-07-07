//
//  StackedView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI




// extension View {
//     func inspectorContent(inspectorContent: () -> some View) -> some View {
//         modifier(InspectorModifierView(inspectorContent: inspectorContent))
//     }
// }
// 
// struct InspectorModifierView: ViewModifier {
//     func body(content: Content) -> some View {
//         content
//             .padding()
//             .background(.quaternary, in: Capsule())
//     }
// }
// 
// 
// struct CardView<Content: View>: View {
//     @EnvironmentObject private var inspectorState: InspectorModel
//     @ViewBuilder let content: Content
// 
//     init(@ViewBuilder content: () -> Content) {
//         self.content = content()
//         self.inspectorState.count += 1
//     }
// 
//     var body: some View {
//         
//     }
// }


struct StackedView<Content: View>: View {
    @EnvironmentObject private var model: Model

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        HStack(alignment: .top) {
            ResizableView(
                fullContent: {
                    ImageView(imageState: model.imageState)
                        .scaledToFit()
                },
                clippedContent: {
                    content()
                })
        }
    }
}

struct StackedView_Previews: PreviewProvider {
    static var previews: some View {
        StackedView {
            Image(systemName: "dot.fill")
        }
    }
}
