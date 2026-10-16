////  WheelAngleCalibrationView.swift
//

import SwiftUI

struct WheelAngleCalibrationView: View {
    private static let progressKey = SavedInputKey.wheelAngleCalibrationProgress

    @State private var progress: WheelAngleCalibration? = GuideProgressStorage.load(
        key: progressKey
    )
    @State private var isShowingSteps = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GuideOverviewScreen(
            title: .wheelAngleCalibrationTitle,
            message: .wheelAngleCalibrationOverviewMessage,
            steps: WheelAngleCalibration.Step.allCases.map(\.overviewStep),
            progress: progress,
            startAction: start,
            resumeAction: resume
        )
        .navigationDestination(isPresented: $isShowingSteps) {
            if let calibration = Binding($progress) {
                WheelAngleCalibrationStepView(calibration: calibration, completeAction: complete)
            }
        }
        .onChange(of: progress) {
            if let progress {
                GuideProgressStorage.save(progress, key: Self.progressKey)
            }
        }
    }

    private func start() {
        progress = WheelAngleCalibration()
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
        WheelAngleCalibrationView()
    }
}
