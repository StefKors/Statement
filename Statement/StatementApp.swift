//
//  StatementApp.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

@main
struct StatementApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: StatementDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
