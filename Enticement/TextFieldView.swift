//
//  TextFieldView.swift
//  Enticement
//
//  Created by Stef Kors on 16/05/2023.
//

import SwiftUI
import CoreData

struct TextFieldView: View {
    @Environment(\.managedObjectContext) private var viewContext

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
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.text = label

            do {
                try viewContext.save()
                viewContext.refresh(newItem, mergeChanges:true)
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
