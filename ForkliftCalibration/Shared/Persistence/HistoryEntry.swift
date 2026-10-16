////  HistoryEntry.swift
//

import Foundation
import SwiftData

@Model
final class HistoryEntry {
    var savedAt: Date
    var check: SavedCheck

    init(check: SavedCheck, savedAt: Date = .now) {
        self.check = check
        self.savedAt = savedAt
    }
}
