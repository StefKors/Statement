//
//  SaveImageToolbarButtonView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI

struct SaveImageToolbarButtonView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        Button("Save Photo") {
            //
            let url = showSavePanel()
            print(url)

            // guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
            // let pngData = bitmapImage.representation(using: .png, properties: [:])
            // do {
            //     try pngData?.write(to: url, options: options)
            //     return true
            // } catch {
            //     print(error)
            //     return false
            // }
        }
    }

    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.jpeg]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.allowsOtherFileTypes = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name"
        savePanel.nameFieldLabel = "File name:"
        let response = savePanel.runModal()
        if response == .OK {
            if let url = savePanel.url {
                return url
            }
        }

        return nil
    }
}

struct SaveImageToolbarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SaveImageToolbarButtonView()
    }
}
