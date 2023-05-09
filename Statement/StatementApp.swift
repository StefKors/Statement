//
//  StatementApp.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

@main
struct StatementApp: App {
    @StateObject private var model = Model()
    @StateObject private var colorCubeFilter = ColorCubeModel()
    @StateObject private var adjustableColorCubeFilter = AdjustableColorCubeModel()
    @StateObject private var sepiaFilter = SepiaModel()

    var body: some Scene {
        WindowGroup("Statement") {
            ContentView()
                .environmentObject(model)
                .environmentObject(sepiaFilter)
                .environmentObject(colorCubeFilter)
                .environmentObject(adjustableColorCubeFilter)
                .buttonStyle(.regularButtonStyle)
                .navigationTitle("Statement")
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
