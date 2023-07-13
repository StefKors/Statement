//
//  ExportControlsView.swift
//  Statement
//
//  Created by Stef Kors on 09/05/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportControlsView: View {
    @EnvironmentObject private var inspector: InspectorModel
    @Environment(\.currentImage) private var currentImage

    @State private var isSaving: Bool = false

    @State private var exportType: UTType = ImageDocument.readableContentTypes[0]

    @State private var exportCompression: NSBitmapImageRep.TIFFCompression = .none

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

            if exportType == .jpeg {
                Picker(selection: $exportCompression) {
                    ForEach(ImageDocument.exportCompressionTypes, id: \.rawValue) { type in
                        Text(NSBitmapImageRep.localizedName(forTIFFCompressionType: type) ?? "")
                            .tag(type)
                    }
                } label: {
                    Text("Compression")
                }
                .pickerStyle(.menu)
                
            }

            SuccessEmojiButton(label: "Export Photo") {
                isSaving.toggle()
            }
            .fileExporter(
                isPresented: $isSaving,
                document: makeDocument(exportCompression),
                contentType: exportType,
                defaultFilename: "edited-image"
            ) { result in
                print(result)
            }
        }
    }

    func makeDocument(_ exportCompression: NSBitmapImageRep.TIFFCompression) -> ImageDocument {
        print("makeDocument")
        let ciImage = inspector.makeEditedImage(ciImage: currentImage)
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        let compression = exportType == .jpeg ? exportCompression : .none
        return ImageDocument(image: nsImage, compression: compression)
    }
}

struct ExportControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ExportControlsView()
    }
}
