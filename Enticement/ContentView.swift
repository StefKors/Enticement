//
//  ContentView.swift
//  Enticement
//
//  Created by Stef Kors on 14/05/2023.
//

import SwiftUI
import CoreData

struct CheckItemView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var item: Item

    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    print("tap!")
                    item.setValue(!item.isCompleted, forKey: "isCompleted")
                    do {
                        try viewContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }
            } label: {
                Label {
                    Text(item.text!)
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
            Spacer()
            Button(role: .destructive) {
                withAnimation(.spring()) {
                    viewContext.delete(item)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var editorContent: String = ""

    var body: some View {
        List {
            TextField("Todo Input", text: $editorContent, prompt: Text("Write here..."))
                .onSubmit {
                    addItem(label: editorContent)
                    editorContent = ""
                }
            ForEach(items) { item in
                HStack {
                    CheckItemView(item: item)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }

    private func addItem(label: String) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.text = label

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
