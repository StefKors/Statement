//
//  ExportControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportControlsView: View {
    @EnvironmentObject private var model: Model

    @State private var isSaving: Bool = false

    @State private var exportType: UTType = ImageDocument.readableContentTypes[0]

    @State private var exportCompression: NSBitmapImageRep.TIFFCompression = .jpeg

    var body: some View {
        Section("Export Options") {
            Picker(selection: $exportType) {
                ForEach(ImageDocument.readableContentTypes, id: \.identifier) { type in
                    Text(type.preferredFilenameExtension ?? type.identifier)
                        .tag(type)
                }
            } label: {
                Text("File Type")
            }



            Picker(selection: $exportCompression) {
                ForEach(ImageDocument.exportCompressionTypes, id: \.rawValue) { type in
                    Text(NSBitmapImageRep.localizedName(forTIFFCompressionType: type) ?? "")
                        .tag(type)
                }
            } label: {
                Text("Compression")
            }
            .pickerStyle(.menu)

            Button("Export Photo") {
                isSaving.toggle()
            }
            .fileExporter(
                isPresented: $isSaving,
                document: model.filteredImageState.image?.makeDocument(exportCompression),
                contentType: exportType,
                defaultFilename: "\(model.enabledFilter.rawValue)-filter"
            ) { result in
                print(result)
            }
        }
    }
}

struct ExportControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ExportControlsView()
    }
}
