////  InputRowView.swift
//

import SwiftUI

struct InputRowView: View {
    let row: SavedCheck.InputRow

    var body: some View {
        LabeledContent {
            switch row.value {
            case .number(let number, let unit):
                HStack(spacing: 4) {
                    Text(verbatim: number)
                        .monospacedDigit()

                    if let unit {
                        Text(unit)
                    }
                }
            case .choice(let choice):
                Text(choice)
            }
        } label: {
            Text(row.label)
        }
    }
}
