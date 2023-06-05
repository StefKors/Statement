//
//  StatementApp.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//


// make use of:
// https://github.com/danwood/SwiftUICoreImage

import SwiftUI

@main
struct StatementApp: App {
    @StateObject var model = Model()
    @StateObject var colorCubeFilter = ColorCubeModel()
    @StateObject var adjustableColorCubeFilter = AdjustableColorCubeModel()
    @StateObject var sepiaFilter = SepiaModel()

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
