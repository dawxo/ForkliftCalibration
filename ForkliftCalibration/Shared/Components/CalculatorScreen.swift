////  CalculatorScreen.swift
//

import SwiftData
import SwiftUI

struct CalculatorScreen<Field: Hashable, Content: View>: View {
    let title: LocalizedStringResource
    let resultBand: ResultBand
    let savedCheck: SavedCheck?
    let focusedField: FocusState<Field?>.Binding
    @ViewBuilder let content: Content

    @Environment(\.modelContext) private var modelContext
    @State private var lastSavedCheck: SavedCheck?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                content
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            dismissKeyboard()
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            resultBand
        }
        .background(Color.appBackground)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                saveButton
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(.keyboardDone) {
                    dismissKeyboard()
                }
                .fontWeight(.semibold)
            }
        }
    }

    private var saveButton: some View {
        Button {
            save()
        } label: {
            Text(isSaved ? .historySaved : .historySave)
        }
        .fontWeight(.semibold)
        .disabled(savedCheck == nil || isSaved)
    }

    private var isSaved: Bool {
        savedCheck != nil && savedCheck == lastSavedCheck
    }

    private func save() {
        guard let savedCheck else {
            return
        }
        modelContext.insert(HistoryEntry(check: savedCheck))
        lastSavedCheck = savedCheck
    }

    private func dismissKeyboard() {
        focusedField.wrappedValue = nil
    }
}
