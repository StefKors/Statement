//
//  InspectorModel.swift
//  Statement
//
//  Created by Stef Kors on 06/07/2023.
//

import SwiftUI

class InspectorModel: ObservableObject {
    @Published var items: [InspectorItem] = []
}
