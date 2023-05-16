//
//  CheckItemView.swift
//  Enticement
//
//  Created by Stef Kors on 16/05/2023.
//

import SwiftUI
import CoreData

struct CheckItemView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var item: Item
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
            if let text = item.text {
                Button {
                    handleTap()
                } label: {
                    Label {
                        //
                    } icon: {
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
                    }
                }
                .buttonStyle(.plain)

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
        }
        .onChange(of: editorContent, perform: { newValue in
            handleSubmit()
        })
        .onChange(of: item) { newValue in
            if let text = newValue.text {
                editorContent = text
            }
        }
        .task(id: item.text) {
            if let text = item.text {
                editorContent = text
            }
        }
        .task(id: item.text) {
            guard let text = item.text else { return }
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
            item.setValue(!item.isCompleted, forKey: "isCompleted")

            do {
                try viewContext.save()
                viewContext.refresh(item, mergeChanges:true)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func handleSubmit() {
        updateItem(label: editorContent)
    }

    private func updateItem(label: String) {
        withAnimation {
            item.setValue(label, forKey: "text")

            do {
                try viewContext.save()
                viewContext.refresh(item, mergeChanges:true)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CheckItemView_Previews: PreviewProvider {
    static var previews: some View {
        CheckItemView(item: Item())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
