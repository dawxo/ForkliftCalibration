////  DistanceCalibrationStepView.swift
//

import SwiftData
import SwiftUI

struct DistanceCalibrationStepView: View {
    @Binding var calibration: DistanceCalibration
    let completeAction: () -> Void

    @State private var isShowingSummary = false
    @FocusState private var focusedWheel: LeftRightCheck.Wheel?
    @FocusState private var focusedField: DistanceScale.Field?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if isShowingSummary {
            GuideSummaryScreen(
                guideName: .distanceCalibrationTitle,
                check: calibration.savedCheck,
                saveAction: {
                    modelContext.insert(HistoryEntry(check: calibration.savedCheck))
                    completeAction()
                },
                discardAction: completeAction
            )
        } else {
            stepScreen
        }
    }

    private var stepScreen: some View {
        GuideStepScreen(
            guide: $calibration,
            guideName: .distanceCalibrationTitle,
            title: calibration.currentStep.title,
            message: calibration.currentStep.message,
            primaryButtonTitle: primaryButtonTitle,
            primaryButtonAction: goForward,
            tryCount: calibration.currentTryCount
        ) {
            switch calibration.currentStep {
            case .leftRightCheck:
                leftRightCheck
            case .distanceRun:
                distanceRun
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(.keyboardDone) {
                    focusedWheel = nil
                    focusedField = nil
                }
                .fontWeight(.semibold)
            }
        }
    }

    private var leftRightCheck: some View {
        VStack(spacing: 10) {
            wheelInputCard(.left, text: $calibration.left)
            wheelInputCard(.right, text: $calibration.right)

            LeftRightCheck.resultBand(left: calibration.left, right: calibration.right)
                .inlineCard()
                .padding(.top, 2)

            if case .over(_, let fartherWheel) = calibration.leftRightOutcome {
                LeftRightAdjustCard(fartherWheel: fartherWheel)
                    .padding(.top, 2)
            }
        }
    }

    private var distanceRun: some View {
        VStack(alignment: .leading, spacing: 10) {
            fieldInputCard(.measured, text: $calibration.measured, unit: .unitMeters)
            fieldInputCard(.computer, text: $calibration.computer, unit: .unitMeters)
            fieldInputCard(.magnification, text: $calibration.magnification)

            DistanceScale.resultBand(
                measured: calibration.measured,
                computer: calibration.computer,
                magnification: calibration.magnification
            )
            .inlineCard()
            .padding(.top, 2)

            if calibration.needsAnotherRun {
                Text(.distanceCalibrationRunAgainNote)
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
                    .padding(.horizontal, 4)
            }
        }
    }

    private func wheelInputCard(
        _ wheel: LeftRightCheck.Wheel,
        text: Binding<String>
    ) -> some View {
        NumberInputCard(
            label: wheel.label,
            unit: .unitMeters,
            text: text,
            isFocused: focusedWheel == wheel
        )
        .focused($focusedWheel, equals: wheel)
    }

    private func fieldInputCard(
        _ field: DistanceScale.Field,
        text: Binding<String>,
        unit: LocalizedStringResource? = nil
    ) -> some View {
        NumberInputCard(
            label: field.label,
            unit: unit,
            text: text,
            isFocused: focusedField == field
        )
        .focused($focusedField, equals: field)
    }

    private var primaryButtonTitle: LocalizedStringResource {
        switch (calibration.currentStep, calibration.needsAnotherRun) {
        case (.leftRightCheck, true): .guideRunAgain
        case (.leftRightCheck, false): .leftRightCheckNext
        case (.distanceRun, true): .guideEnteredOnAGV
        case (.distanceRun, false): .guideFinish
        }
    }

    private func goForward() {
        if calibration.needsAnotherRun {
            calibration.startAnotherRun()
        } else if let nextStep = calibration.nextStep {
            calibration.currentStep = nextStep
        } else {
            isShowingSummary = true
        }
    }
}

#Preview {
    @Previewable @State var calibration = DistanceCalibration()

    NavigationStack {
        DistanceCalibrationStepView(calibration: $calibration) {}
    }
}
