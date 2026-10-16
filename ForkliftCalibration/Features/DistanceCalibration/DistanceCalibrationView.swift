////  DistanceCalibrationView.swift
//

import SwiftUI

struct DistanceCalibrationView: View {
    private static let progressKey = SavedInputKey.distanceCalibrationProgress

    @State private var progress: DistanceCalibration? = GuideProgressStorage.load(
        key: progressKey
    )
    @State private var isShowingSteps = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GuideOverviewScreen(
            title: .distanceCalibrationTitle,
            message: .distanceCalibrationOverviewMessage,
            steps: DistanceCalibration.Step.allCases.map(\.overviewStep),
            progress: progress,
            startAction: start,
            resumeAction: resume
        )
        .navigationDestination(isPresented: $isShowingSteps) {
            if let calibration = Binding($progress) {
                DistanceCalibrationStepView(calibration: calibration, completeAction: complete)
            }
        }
        .onChange(of: progress) {
            if let progress {
                GuideProgressStorage.save(progress, key: Self.progressKey)
            }
        }
    }

    private func start() {
        progress = DistanceCalibration()
        isShowingSteps = true
    }

    private func resume() {
        isShowingSteps = true
    }

    private func complete() {
        GuideProgressStorage.clear(key: Self.progressKey)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        DistanceCalibrationView()
    }
}
