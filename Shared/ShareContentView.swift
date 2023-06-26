//
//  ShareContentView.swift
//  iOSShareExtension
//
//  Created by Stef Kors on 26/06/2023.
//

import UIKit
import SwiftData
import SwiftUI
import UniformTypeIdentifiers

struct ShareContentView: View {
    @Environment(\.extensionContext) private var extensionContext: NSExtensionContext?
    @Environment(\.modelContext) private var modelContext

    @State private var url: URL? = nil

    var body: some View {
        VStack(spacing: 50) {
            LinkView(url: url)

            Button {
                submit()
            } label: {
                Text("Add to Enticement")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        // .toolbar(content: {
        //     ToolbarItem(placement: .cancellationAction) {
        //         Button("close", action: close)
        //     }
        // })
        .task {
            var identifiers: [String] = []
            if let extensionContext {
                for inputItem in extensionContext.inputItems {
                    if let extensionitem = inputItem as? NSExtensionItem {
                        if let attachments = extensionitem.attachments {
                            for attachment in attachments {
                                let items = attachment.registeredTypeIdentifiers
                                identifiers.append(contentsOf: items)
                                if let secureValue = try? await attachment.loadItem(forTypeIdentifier: "public.url") {
                                    if let url = secureValue as? URL {
                                        self.url = url
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func submit() {
        if let url {
            let newItem = EntryItem(timestamp: Date.now, text: url.description, isCompleted: false)
            modelContext.insert(newItem)
            extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    func close() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}


#Preview {
    ShareContentView()
        .modelContainer(for: EntryItem.self, inMemory: true)
}
