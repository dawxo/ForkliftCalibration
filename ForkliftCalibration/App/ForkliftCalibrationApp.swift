////  ForkliftCalibrationApp.swift
//

import SwiftData
import SwiftUI

@main
struct ForkliftCalibrationApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(for: HistoryEntry.self)
    }
}
