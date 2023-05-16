//
//  ContentView.swift
//  Enticement
//
//  Created by Stef Kors on 14/05/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)
        ],
        animation: .spring())

    private var items: FetchedResults<Item>
    //
    // private var dict: [String: [FetchedResults<Item>.Element]] {
    //     Dictionary(grouping: items, by: { $0.isCompleted.description })
    // }

    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    CheckItemView(item: item)
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .opacity
                        ))
                }
            }
            .onDelete(perform: deleteItems)
        }
        .safeAreaInset(edge: .bottom) {
            Divider()
            TextFieldView()
                .padding()
                .frame(maxWidth: .infinity)
                .background(.background)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
