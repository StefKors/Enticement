//
//  EnticementApp.swift
//  Enticement
//
//  Created by Stef Kors on 14/05/2023.
//

import SwiftUI
import SwiftData

@main
struct EnticementApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: EntryItem.self)
    }
}
