//
//  CheckItemView.swift
//  Enticement
//
//  Created by Stef Kors on 16/05/2023.
//

import SwiftUI
import CoreData

struct CheckItemView: View {
    @Environment(\.modelContext) private var modelContext
    var item: EntryItem
    @State private var isPresentWebView = false

    @State private var editorContent: String = ""
    @State private var browserUrl: URL?

    enum Field: Hashable {
        case generalInput
        // case inlineInput
    }

    @FocusState private var focus: Field?

    var body: some View {
        HStack {
            Button {
                handleTap()
            } label: {
                ZStack {
                    if item.isCompleted {
                        Circle().fill()
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Circle().stroke()
                            .transition(.scale.combined(with: .opacity))
                        Circle().fill().opacity(0.3)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .clipShape(Circle())
                .frame(maxHeight: 20)
            }

            TextField("Todo Input", text: $editorContent, prompt: Text("Write here..."))
                .submitScope(true)
                .submitLabel(.next)
                .focused($focus, equals: .generalInput)
                .onSubmit(of: .text, {
                    print("submit text")
                })
                .onSubmit {
                    print("submit generic")
                    // handleSubmit()
                }

            Spacer()
            if let browserUrl {
                Button {
                    isPresentWebView = true
                } label: {
                    Image(systemName: "globe")
                }
                .sheet(isPresented: $isPresentWebView) {
                    SafariWebView(url: browserUrl)
                        .ignoresSafeArea()
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .onChange(of: editorContent, perform: { newValue in
            handleSubmit()
        })
        .onChange(of: item) { newValue in
            editorContent = item.text
        }
        .task(id: item.text) {
            editorContent = item.text
        }
        .task(id: item.text) {
            let text = item.text
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

            var urls = [URL]()
            for match in matches {
                guard let range = Range(match.range, in: text) else { continue }
                let substr = text[range]
                guard let url = URL(string: substr.string) else { continue }
                urls.append(url)
            }
            self.browserUrl = urls.first
        }
    }

    func handleTap() {
        withAnimation(.spring()) {
            item.setValue(for: \.isCompleted, to: !item.isCompleted)
        }
    }

    private func handleSubmit() {
        updateItem(label: editorContent)
    }

    private func updateItem(label: String) {
        withAnimation {
            item.setValue(for: \.text, to: label)
        }
    }
}

struct CheckItemView_Previews: PreviewProvider {
    static var previews: some View {
        CheckItemView(item: .preview)
            .modelContainer(for: EntryItem.self, inMemory: true)
    }
}
