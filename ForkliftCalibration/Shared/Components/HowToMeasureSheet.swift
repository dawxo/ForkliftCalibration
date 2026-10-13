////  HowToMeasureSheet.swift
//

import SwiftUI

struct HowToMeasureSheet<Diagram: View>: View {
    let steps: [LocalizedStringResource]
    @ViewBuilder let diagram: Diagram

    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .body) private var badgeSize = 34.0

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
                            stepRow(number: index + 1, text: steps[index])
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

    private func stepRow(number: Int, text: LocalizedStringResource) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 14) {
            Text(number, format: .number)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.onAccent)
                .frame(width: badgeSize, height: badgeSize)
                .background(Color.accentFill, in: .circle)

            Text(text)
                .font(.title3)
                .foregroundStyle(Color.primaryText)
        }
        .accessibilityElement(children: .combine)
    }
}
