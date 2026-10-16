////  Home.swift
//

import SwiftUI

struct HomeView: View {
    @AppStorage(SavedInputKey.wheelAngleCalibrationProgress)
    private var wheelAngleCalibrationProgressData: Data?
    @AppStorage(SavedInputKey.distanceCalibrationProgress)
    private var distanceCalibrationProgressData: Data?

    var body: some View {
        NavigationStack {
            List {
                Section(.homeSectionWheelbaseSpin) {
                    NavigationLink {
                        WheelAngleCalibrationView()
                    } label: {
                        guideRow(
                            title: .wheelAngleCalibrationTitle,
                            subtitle: .homeWheelAngleCalibrationSubtitle,
                            progress: wheelAngleCalibrationProgress
                        )
                    }
                    NavigationLink(value: CalculatorRoute.angleCorrection) {
                        HomeRow(
                            tile: .calculator,
                            title: CalculatorRoute.angleCorrection.title,
                            subtitle: .homeAngleCorrectionSubtitle
                        )
                    }
                }
                Section(.homeSectionDistance) {
                    NavigationLink {
                        DistanceCalibrationView()
                    } label: {
                        guideRow(
                            title: .distanceCalibrationTitle,
                            subtitle: .homeDistanceCalibrationSubtitle,
                            progress: distanceCalibrationProgress
                        )
                    }
                    NavigationLink(value: CalculatorRoute.leftRightCheck) {
                        HomeRow(
                            tile: .calculator,
                            title: CalculatorRoute.leftRightCheck.title,
                            subtitle: .homeLeftRightCheckSubtitle
                        )
                    }
                    NavigationLink(value: CalculatorRoute.distanceScale) {
                        HomeRow(
                            tile: .calculator,
                            title: CalculatorRoute.distanceScale.title,
                            subtitle: .homeDistanceScaleSubtitle
                        )
                    }
                }
                Section(.homeSectionForks) {
                    NavigationLink(value: CalculatorRoute.offset) {
                        HomeRow(
                            tile: .calculator,
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

    private var wheelAngleCalibrationProgress: WheelAngleCalibration? {
        GuideProgressStorage.decode(wheelAngleCalibrationProgressData)
    }

    private var distanceCalibrationProgress: DistanceCalibration? {
        GuideProgressStorage.decode(distanceCalibrationProgressData)
    }

    private func guideRow(
        title: LocalizedStringResource,
        subtitle: LocalizedStringResource,
        progress: (some Guide)?
    ) -> HomeRow {
        guard let progress else {
            return HomeRow(tile: .guide, title: title, subtitle: subtitle)
        }
        return HomeRow(
            tile: .guide,
            title: title,
            subtitle: .homeGuideInProgress(progress.stepNumber, progress.stepCount),
            stepStates: progress.stepStates
        )
    }
}

#Preview {
    HomeView()
}
