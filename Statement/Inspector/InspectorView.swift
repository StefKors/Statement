//
//  InspectorView.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//  based on a bunch of examples like: https://www.swiftbysundell.com/articles/deep-dive-into-swift-function-builders/

import SwiftUI

extension View {
    func makeInspector(@InspectorItemsBuilder _ items: @escaping () -> [InspectorItem]) -> some View {
        modifier(MakeInspectorModifier(items: items))
    }
}

struct MakeInspectorModifier: ViewModifier {
    @EnvironmentObject private var inspectorState: InspectorModel

    let items: () -> [InspectorItem]


    init(@InspectorItemsBuilder items: @escaping () -> [InspectorItem]) {
        self.items = items
    }

    func body(content: Content) -> some View {
        content
            .task {
                // Is there a better way to update the state?
                print("found items \(items().count)")
                self.inspectorState.items = items()
            }
    }
}

extension InspectorItem: InspectorItemsConvertible {
    func asInspectorItems() -> [InspectorItem] { [self] }
}

extension InspectorItem {
    struct Empty: InspectorItemsConvertible {
        func asInspectorItems() -> [InspectorItem] { [] }
    }
}

@resultBuilder
struct InspectorItemsBuilder {
    static func buildBlock() -> [InspectorItem] { [] }
}

extension InspectorItemsBuilder {
    static func buildBlock(_ InspectorItems: InspectorItem...) -> [InspectorItem] {
        InspectorItems
    }
}

extension InspectorItemsBuilder {
    static func buildBlock(_ values: InspectorItemsConvertible...) -> [InspectorItem] {
        values.flatMap { $0.asInspectorItems() }
    }
}

// Here we extend Array to make it conform to our InspectorItemsConvertible
// protocol, in order to be able to return an empty array from our
// 'buildIf' implementation in case a nil value was passed:
extension Array: InspectorItemsConvertible where Element == InspectorItem {
    func asInspectorItems() -> [InspectorItem] { self }
}

extension InspectorItemsBuilder {
    static func buildIf(_ value: InspectorItemsConvertible?) -> InspectorItemsConvertible {
        value ?? []
    }
}

extension InspectorItemsBuilder {
    static func buildEither(first: InspectorItemsConvertible) -> InspectorItemsConvertible {
        first
    }

    static func buildEither(second: InspectorItemsConvertible) -> InspectorItemsConvertible {
        second
    }
}

protocol InspectorItemsConvertible {
    func asInspectorItems() -> [InspectorItem]
}

// struct InspectorItemsGroup {
//     var name: String
//     @InspectorItemsBuilder var InspectorItems: () -> [InspectorItem]
// }
// 
// extension InspectorItemsGroup: InspectorItemsConvertible {
//     func asInspectorItems() -> [InspectorItem] {
//         [InspectorItem(name: name)]
//     }
// }
