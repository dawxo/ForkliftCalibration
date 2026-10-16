////  Home.swift
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(.homeSectionWheelbaseSpin) {
                    NavigationLink(value: CalculatorRoute.angleCorrection) {
                        HomeRow(
                            title: CalculatorRoute.angleCorrection.title,
                            subtitle: .homeAngleCorrectionSubtitle
                        )
                    }
                }
                Section(.homeSectionDistance) {
                    NavigationLink(value: CalculatorRoute.leftRightCheck) {
                        HomeRow(
                            title: CalculatorRoute.leftRightCheck.title,
                            subtitle: .homeLeftRightCheckSubtitle
                        )
                    }
                    NavigationLink(value: CalculatorRoute.distanceScale) {
                        HomeRow(
                            title: CalculatorRoute.distanceScale.title,
                            subtitle: .homeDistanceScaleSubtitle
                        )
                    }
                }
                Section(.homeSectionForks) {
                    NavigationLink(value: CalculatorRoute.offset) {
                        HomeRow(
                            title: CalculatorRoute.offset.title,
                            subtitle: .homeOffsetSubtitle
                        )
                    }
                }
            }
            .listStyle(.insetGrouped)
            .environment(\.defaultMinListRowHeight, 80)
            .navigationTitle(.homeTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HistoryView()
                    } label: {
                        Label(.historyTitle, systemImage: "clock.arrow.circlepath")
                    }
                }
            }
            .navigationDestination(for: CalculatorRoute.self) { route in
                switch route {
                case .angleCorrection:
                    AngleCorrectionView()
                case .leftRightCheck:
                    LeftRightCheckView()
                case .distanceScale:
                    DistanceScaleView()
                case .offset:
                    OffsetView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
