////  HistoryDetailView.swift
//

import SwiftUI

struct HistoryDetailView: View {
    let entry: HistoryEntry

    @State private var isShowingCalculator = false

    var body: some View {
        let rows = entry.check.inputRows

        List {
            Section {
                ForEach(rows.indices, id: \.self) { index in
                    inputRow(rows[index])
                }
            } header: {
                Text(entry.savedAt, format: .dateTime.weekday(.wide).month().day().hour().minute())
            }

            Section {
                Button(.historyUseTheseValues) {
                    entry.check.restoreInputs()
                    isShowingCalculator = true
                }
                .buttonStyle(.primary)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .top, spacing: 0) {
            entry.check.resultBand
        }
        .navigationTitle(entry.check.route.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isShowingCalculator) {
            calculator
        }
    }

    private func inputRow(_ row: SavedCheck.InputRow) -> some View {
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

    @ViewBuilder
    private var calculator: some View {
        switch entry.check {
        case .angleCorrection(_, let spinOutcome, _, _):
            AngleCorrectionView(spinOutcome: spinOutcome)
        case .leftRightCheck:
            LeftRightCheckView()
        case .distanceScale:
            DistanceScaleView()
        case .offset:
            OffsetView()
        }
    }
}
