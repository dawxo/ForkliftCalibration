////  HistoryRow.swift
//

import SwiftUI

struct HistoryRow: View {
    let entry: HistoryEntry

    var body: some View {
        let summary = entry.check.summary

        HStack(spacing: 14) {
            Image(systemName: summary.status.symbolName)
                .font(.title2)
                .foregroundStyle(summary.status.color)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.check.route.title)
                    .font(.headline)
                    .foregroundStyle(Color.primaryText)

                Text(summary.resultLine)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }

            Spacer()

            Text(entry.savedAt, format: .dateTime.hour().minute())
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)
        }
        .padding(.vertical, 6)
    }
}

extension SavedCheck.Status {
    var symbolName: String {
        switch self {
        case .pass: "checkmark.circle.fill"
        case .fail: "exclamationmark.triangle.fill"
        case .neutral: "equal.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .pass: .passText
        case .fail: .errorText
        case .neutral: .accentFill
        }
    }
}
