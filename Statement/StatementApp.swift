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
    @StateObject var sepiaFilter = SepiaModel()
    @StateObject var inspector = InspectorModel()

    var body: some Scene {
        WindowGroup("Statement") {
            ContentView()
                .environmentObject(model)
                .environmentObject(sepiaFilter)
                .environmentObject(inspector)
                .buttonStyle(.regularButtonStyle)
                .navigationTitle("Statement")
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
