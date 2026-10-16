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
                    InputRowView(row: rows[index])
                }
            } header: {
                Text(entry.savedAt, format: .dateTime.weekday(.wide).month().day().hour().minute())
            }

            if entry.check.restoresIntoCalculator {
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
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .top, spacing: 0) {
            entry.check.resultBand
        }
        .navigationTitle(entry.check.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isShowingCalculator) {
            calculator
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
        case .wheelAngleCalibration, .distanceCalibration:
            EmptyView()
        }
    }
}
