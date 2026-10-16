////  HowToMeasureSheet.swift
//

import SwiftUI

struct HowToMeasureSheet<Diagram: View>: View {
    let steps: [LocalizedStringResource]
    @ViewBuilder let diagram: Diagram

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 26) {
                    diagram
                        .padding(.vertical, 18)
                        .padding(.horizontal, 16)
                        .background(Color.cellBackground, in: .rect(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 18) {
                        ForEach(steps.indices, id: \.self) { index in
                            NumberedStepRow(number: index + 1, text: steps[index])
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .background(Color.appBackground)
            .navigationTitle(.howToMeasureTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(.sheetDone) {
                        dismiss()
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}
