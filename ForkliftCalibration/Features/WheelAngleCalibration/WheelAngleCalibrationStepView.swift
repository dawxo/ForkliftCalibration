////  WheelAngleCalibrationStepView.swift
//

import SwiftData
import SwiftUI

struct WheelAngleCalibrationStepView: View {
    @Binding var calibration: WheelAngleCalibration
    let completeAction: () -> Void

    @State private var isShowingSummary = false
    @FocusState private var focusedField: AngleCorrection.Field?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        if isShowingSummary, let savedCheck = calibration.savedCheck {
            GuideSummaryScreen(
                guideName: .wheelAngleCalibrationTitle,
                check: savedCheck,
                saveAction: {
                    modelContext.insert(HistoryEntry(check: savedCheck))
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
            guideName: .wheelAngleCalibrationTitle,
            title: calibration.currentStep.title,
            message: message,
            primaryButtonTitle: primaryButtonTitle,
            primaryButtonAction: goForward
        ) {
            stepContent
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(.keyboardDone) {
                    focusedField = nil
                }
                .fontWeight(.semibold)
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch calibration.currentStep {
        case .bind:
            GuideConfirmCard(label: .wheelAngleCalibrationBound, isConfirmed: $calibration.isBound)
        case .spinCounterclockwise:
            spinStep(.counterclockwise, result: $calibration.counterclockwise)
        case .bindAgain:
            GuideConfirmCard(
                label: .wheelAngleCalibrationBound,
                isConfirmed: $calibration.isBoundAgain
            )
        case .spinClockwise:
            spinStep(.clockwise, result: $calibration.clockwise)

            if let nextStepNote {
                Text(nextStepNote)
                    .font(.body)
                    .foregroundStyle(Color.secondaryText)
                    .padding(.horizontal, 4)
            }
        case .correctWheelbase:
            correctWheelbase
        }
    }

    private func spinStep(
        _ spinDirection: AngleCorrection.SpinDirection,
        result: Binding<WheelAngleCalibration.SpinResult?>
    ) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(spinDirection.spinSteps.indices, id: \.self) { index in
                    NumberedStepRow(number: index + 1, text: spinDirection.spinSteps[index])
                }
            }
            .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(.wheelAngleCalibrationSpinQuestion)
                    .font(.headline)
                    .foregroundStyle(Color.secondaryText)
                    .padding(.horizontal, 20)

                SpinPicker(selection: result, spinDirection: spinDirection)
            }
        }
    }

    private var correctWheelbase: some View {
        VStack(spacing: 10) {
            spinResultsCard
                .padding(.bottom, 2)

            inputCard(.amount, text: $calibration.amount, unit: .unitDegrees)
            inputCard(.wheelbase, text: $calibration.wheelbase)

            calibration.resultBand
                .inlineCard()
                .padding(.top, 2)
        }
    }

    private var spinResultsCard: some View {
        VStack(spacing: 0) {
            spinResultRow(.counterclockwise, result: calibration.counterclockwise)

            Rectangle()
                .fill(Color.separatorLine)
                .frame(height: 1)

            spinResultRow(.clockwise, result: calibration.clockwise)
        }
        .background(Color.cellBackground, in: .rect(cornerRadius: 20))
    }

    private func spinResultRow(
        _ spinDirection: AngleCorrection.SpinDirection,
        result: WheelAngleCalibration.SpinResult?
    ) -> some View {
        LabeledContent {
            if let result {
                Text(result.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(result == .withinLimit ? Color.passText : Color.errorText)
            }
        } label: {
            Text(spinDirection.title)
                .font(.body)
                .foregroundStyle(Color.primaryText)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 20)
        .frame(minHeight: 52)
    }

    private func inputCard(
        _ field: AngleCorrection.Field,
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

    private var message: LocalizedStringResource? {
        switch calibration.currentStep {
        case .bind: .wheelAngleCalibrationBindMessage
        case .bindAgain: .wheelAngleCalibrationBindAgainMessage
        case .spinCounterclockwise, .spinClockwise: nil
        case .correctWheelbase:
            switch calibration.correctedSpinDirection {
            case .counterclockwise: .wheelAngleCalibrationCorrectCounterclockwiseMessage
            case .clockwise, nil: .wheelAngleCalibrationCorrectClockwiseMessage
            }
        }
    }

    private var nextStepNote: LocalizedStringResource? {
        guard calibration.clockwise != nil else {
            return nil
        }
        if calibration.isSkipped(.correctWheelbase) {
            return .wheelAngleCalibrationNoteSkipped
        }
        return switch (calibration.correctedSpinDirection, calibration.correctedSpinOutcome) {
        case (.counterclockwise, .under): .wheelAngleCalibrationNoteCounterclockwiseUnder
        case (.counterclockwise, .over): .wheelAngleCalibrationNoteCounterclockwiseOver
        case (.clockwise, .under): .wheelAngleCalibrationNoteClockwiseUnder
        case (.clockwise, .over): .wheelAngleCalibrationNoteClockwiseOver
        default: nil
        }
    }

    private var primaryButtonTitle: LocalizedStringResource {
        if calibration.currentStep == .correctWheelbase {
            .guideEnteredOnAGV
        } else if calibration.nextStep == nil {
            .guideFinish
        } else {
            .guideNext
        }
    }

    private func goForward() {
        if let nextStep = calibration.nextStep {
            calibration.currentStep = nextStep
        } else {
            isShowingSummary = true
        }
    }
}

#Preview {
    @Previewable @State var calibration = WheelAngleCalibration()

    NavigationStack {
        WheelAngleCalibrationStepView(calibration: $calibration) {}
    }
}
