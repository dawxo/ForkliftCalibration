////  CalculatorScreen.swift
//

import SwiftUI

struct CalculatorScreen<Field: Hashable, Content: View>: View {
    let title: LocalizedStringResource
    let resultBand: ResultBand
    let focusedField: FocusState<Field?>.Binding
    @ViewBuilder let content: Content

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
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(.keyboardDone) {
                    dismissKeyboard()
                }
                .fontWeight(.semibold)
            }
        }
    }

    private func dismissKeyboard() {
        focusedField.wrappedValue = nil
    }
}
