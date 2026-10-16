////  HistoryView.swift
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    @Query(sort: \HistoryEntry.savedAt, order: .reverse) private var entries: [HistoryEntry]
    @Environment(\.modelContext) private var modelContext
    @State private var isConfirmingClear = false

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableView {
                    Label(.historyEmptyTitle, systemImage: "clock.arrow.circlepath")
                } description: {
                    Text(.historyEmptyMessage)
                }
            } else {
                List {
                    ForEach(days, id: \.day) { day in
                        Section {
                            ForEach(day.entries) { entry in
                                NavigationLink {
                                    HistoryDetailView(entry: entry)
                                } label: {
                                    HistoryRow(entry: entry)
                                }
                                .swipeActions {
                                    deleteButton(for: entry)
                                }
                            }
                        } header: {
                            dayTitle(day.day)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .background(Color.appBackground)
        .navigationTitle(.historyTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(.historyClear, role: .destructive) {
                    isConfirmingClear = true
                }
                .disabled(entries.isEmpty)
            }
        }
        .confirmationDialog(
            Text(.historyClearTitle),
            isPresented: $isConfirmingClear,
            titleVisibility: .visible
        ) {
            Button(.historyClearConfirm, role: .destructive) {
                clearAll()
            }
        } message: {
            Text(.historyClearMessage)
        }
    }

    private var days: [(day: Date, entries: [HistoryEntry])] {
        Dictionary(grouping: entries) { Calendar.current.startOfDay(for: $0.savedAt) }
            .sorted { $0.key > $1.key }
            .map { (day: $0.key, entries: $0.value) }
    }

    private func dayTitle(_ day: Date) -> Text {
        if Calendar.current.isDateInToday(day) {
            Text(.historyToday)
        } else if Calendar.current.isDateInYesterday(day) {
            Text(.historyYesterday)
        } else {
            Text(day, format: .dateTime.weekday(.wide).month(.abbreviated).day())
        }
    }

    private func clearAll() {
        for entry in entries {
            modelContext.delete(entry)
        }
    }

    private func deleteButton(for entry: HistoryEntry) -> some View {
        Button(role: .destructive) {
            modelContext.delete(entry)
        } label: {
            Label(.historyDelete, systemImage: "trash")
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
    .modelContainer(for: HistoryEntry.self, inMemory: true)
}
