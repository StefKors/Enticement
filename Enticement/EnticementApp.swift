//
//  EnticementApp.swift
//  Enticement
//
//  Created by Stef Kors on 14/05/2023.
//

import SwiftUI

@main
struct EnticementApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
