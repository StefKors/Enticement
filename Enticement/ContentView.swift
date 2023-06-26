//
//  ContentView.swift
//  Enticement
//
//  Created by Stef Kors on 14/05/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        // SortDescriptor(\.isCompleted.description, order: .forward),
        SortDescriptor(\.timestamp, order: .reverse)
    ], animation: .spring()) private var items: [EntryItem]

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
            offsets.map { items[$0] }.forEach { item in
                modelContext.delete(object: item)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: EntryItem.self, inMemory: true)
    }
}
