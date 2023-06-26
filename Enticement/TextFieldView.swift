//
//  TextFieldView.swift
//  Enticement
//
//  Created by Stef Kors on 16/05/2023.
//

import SwiftUI
import CoreData

struct TextFieldView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var editorContent: String = ""
    enum Field: Hashable {
        case generalInput
        // case inlineInput
    }

    @FocusState private var focus: Field?

    var isEnabled: Bool {
        !editorContent.isEmpty
    }

    var body: some View {
        HStack {
            TextField("Write here...", text: $editorContent) { editingState in
                /// The action to perform when the user begins editing text and after the user finishes editing text.
                /// The closure receives a Boolean value that indicates the editing status: true when the user begins editing, false when they finish.

                let hasFinished = editingState == false
                print("onSubmit hasFinished: \(hasFinished.description)")
                if hasFinished, isEnabled {
                    handleSubmit()
                    // focus = .generalInput
                    editorContent = ""
                }
            }
            .keyboardType(.twitter)
            // .focused($focus, equals: .generalInput)

            Button(action: handleSubmit) {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(Color.accentColor)
            }
            .disabled(!isEnabled)
        }
    }

    private func handleSubmit() {
        addItem(label: editorContent)
        editorContent = ""
    }

    private func addItem(label: String) {
        withAnimation {
            let newItem = EntryItem(timestamp: Date.now, text: label, isCompleted: false)
            modelContext.insert(newItem)
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
            .modelContainer(for: EntryItem.self, inMemory: true)
    }
}
