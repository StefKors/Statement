//
//  StatementApp.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

@main
struct StatementApp: App {
    @StateObject var model = Model()
    var body: some Scene {
        WindowGroup("Statement") {
            ContentView()
                .environmentObject(model)
                .buttonStyle(.regularButtonStyle)
                .navigationTitle("Statement")
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
