//
//  Item.swift
//  OverlandKit
//
//  Created by Stef Kors on 23/06/2023.
//

import Foundation
import Observation
import SwiftData

@Model class EntryItem {
    @Attribute(.unique) var id: String
    var timestamp: Date
    var text: String
    var isCompleted: Bool

    init(timestamp: Date, text: String, isCompleted: Bool) {
        self.id = UUID().uuidString
        self.timestamp = timestamp
        self.text = text
        self.isCompleted = isCompleted
    }

    static let preview = EntryItem(timestamp: Date.now, text: "test string", isCompleted: true)
}
