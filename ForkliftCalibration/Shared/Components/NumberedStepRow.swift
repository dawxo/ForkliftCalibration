////  NumberedStepRow.swift
//

import SwiftUI

struct NumberedStepRow: View {
    let number: Int
    let text: LocalizedStringResource

    @ScaledMetric(relativeTo: .body) private var badgeSize = 34.0

    var body: some View {
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
