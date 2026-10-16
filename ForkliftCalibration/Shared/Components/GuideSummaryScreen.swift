////  GuideSummaryScreen.swift
//

import SwiftUI

struct GuideSummaryScreen: View {
    let guideName: LocalizedStringResource
    let check: SavedCheck
    let saveAction: () -> Void
    let discardAction: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                GuideHeader(
                    caption: guideName,
                    title: .guideSummaryTitle,
                    message: .guideSummaryMessage
                )

                check.resultBand
                    .inlineCard()

                VStack(alignment: .leading, spacing: 8) {
                    Text(.guideSummaryRows)
                        .font(.headline)
                        .foregroundStyle(Color.secondaryText)
                        .padding(.horizontal, 20)

                    summaryRows
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 22)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            GuideBottomBar {
                Button(.guideDontSave, action: discardAction)
                    .buttonStyle(.secondary)

                Button(.guideSaveToHistory, action: saveAction)
                    .buttonStyle(.primary)
            }
        }
        .background(Color.appBackground)
        .navigationTitle(.guideComplete)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var summaryRows: some View {
        let rows = check.inputRows

        return VStack(spacing: 0) {
            ForEach(rows.indices, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(Color.separatorLine)
                        .frame(height: 1)
                }
                InputRowView(row: rows[index])
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
            }
        }
        .background(Color.cellBackground, in: .rect(cornerRadius: 20))
    }
}
