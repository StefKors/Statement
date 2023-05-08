//
//  ContentView.swift
//  Statement
//
//  Created by Stef Kors on 08/05/2023.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: StatementDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(StatementDocument()))
    }
}
