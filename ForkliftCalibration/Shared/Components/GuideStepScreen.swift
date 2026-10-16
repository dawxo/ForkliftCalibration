////  GuideStepScreen.swift
//

import SwiftUI

struct GuideStepScreen<GuideType: Guide, Content: View>: View {
    @Binding var guide: GuideType
    let guideName: LocalizedStringResource
    let title: LocalizedStringResource
    let message: LocalizedStringResource?
    let primaryButtonTitle: LocalizedStringResource
    let primaryButtonAction: () -> Void
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                GuideHeader(caption: guideName, title: title, message: message)
                content
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 22)
        }
        .scrollDismissesKeyboard(.interactively)
        .id(guide.currentStep)
        .safeAreaInset(edge: .top, spacing: 0) {
            GuideProgressBar(stepStates: guide.stepStates)
                .padding(.horizontal, 16)
                .padding(.top, 6)
                .padding(.bottom, 10)
                .background(Color.appBackground)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
        }
        .background(Color.appBackground)
        .navigationTitle(.guideStep(guide.stepNumber, guide.stepCount))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var bottomBar: some View {
        GuideBottomBar {
            if let previousStep = guide.previousStep {
                Button(.guideBack) {
                    guide.currentStep = previousStep
                }
                .buttonStyle(.secondary)
            }

            Button(primaryButtonTitle, action: primaryButtonAction)
                .buttonStyle(.primary)
                .disabled(!guide.canContinue)
        }
    }
}

#Preview {
    @Previewable @State var calibration = WheelAngleCalibration(
        currentStep: .bindAgain,
        isBound: true,
        isBoundAgain: true,
        counterclockwise: .under
    )

    NavigationStack {
        GuideStepScreen(
            guide: $calibration,
            guideName: .wheelAngleCalibrationTitle,
            title: .wheelAngleCalibrationBindTitle,
            message: .wheelAngleCalibrationBindMessage,
            primaryButtonTitle: .guideNext
        ) {
            if let nextStep = calibration.nextStep {
                calibration.currentStep = nextStep
            }
        } content: {
            Color.cellBackground
                .frame(height: 200)
        }
    }
}
