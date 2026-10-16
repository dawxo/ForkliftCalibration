////  WheelAngleCalibration+Display.swift
//

import SwiftUI

extension WheelAngleCalibration {
    var resultBand: ResultBand {
        if isSkipped(.correctWheelbase) {
            ResultBand(
                label: .guideResultLabel,
                content: .instruction(.wheelAngleCalibrationBothWithinLimit)
            )
        } else {
            AngleCorrection.resultBand(
                spinOutcome: correctedSpinOutcome,
                amount: amount,
                wheelbase: wheelbase
            )
        }
    }

    var savedCheck: SavedCheck? {
        guard let counterclockwise, let clockwise else {
            return nil
        }
        let isCorrected = !isSkipped(.correctWheelbase)
        return .wheelAngleCalibration(
            counterclockwise: counterclockwise,
            clockwise: clockwise,
            amount: isCorrected ? amount : "",
            wheelbase: isCorrected ? wheelbase : ""
        )
    }
}

extension WheelAngleCalibration.Step {
    var overviewStep: GuideOverviewStep {
        GuideOverviewStep(title: title, detail: overviewDetail)
    }

    var title: LocalizedStringResource {
        switch self {
        case .bind: .wheelAngleCalibrationBindTitle
        case .spinCounterclockwise: .wheelAngleCalibrationSpinCounterclockwiseTitle
        case .bindAgain: .wheelAngleCalibrationBindAgainTitle
        case .spinClockwise: .wheelAngleCalibrationSpinClockwiseTitle
        case .correctWheelbase: .wheelAngleCalibrationCorrectTitle
        }
    }

    private var overviewDetail: LocalizedStringResource {
        switch self {
        case .bind, .bindAgain: .guideOverviewConfirm
        case .spinCounterclockwise, .spinClockwise: .wheelAngleCalibrationOverviewSpinDetail
        case .correctWheelbase: .wheelAngleCalibrationOverviewCorrectDetail
        }
    }
}

extension WheelAngleCalibration.SpinResult: SpinPickerOption {
    var title: LocalizedStringResource {
        switch self {
        case .withinLimit: .wheelAngleCalibrationSpinResultWithinLimit
        case .under: .angleCorrectionSpinOutcomeUnder
        case .over: .angleCorrectionSpinOutcomeOver
        }
    }

    var caption: LocalizedStringResource {
        switch self {
        case .withinLimit: .wheelAngleCalibrationSpinResultOnTheLine
        case .under: .angleCorrectionSpinOutcomeStoppedShort
        case .over: .angleCorrectionSpinOutcomeWentPast
        }
    }

    func diagram(isSelected: Bool) -> ImageResource {
        switch (self, isSelected) {
        case (.withinLimit, false): .angleWithin
        case (.withinLimit, true): .angleWithinSelected
        case (.under, false): .angleUnder
        case (.under, true): .angleUnderSelected
        case (.over, false): .angleOver
        case (.over, true): .angleOverSelected
        }
    }
}

extension AngleCorrection.SpinDirection {
    var spinSteps: [LocalizedStringResource] {
        switch self {
        case .counterclockwise:
            [
                .wheelAngleCalibrationCounterclockwiseTurn,
                .wheelAngleCalibrationCounterclockwiseSpin,
                .wheelAngleCalibrationCheckStop,
            ]
        case .clockwise:
            [
                .wheelAngleCalibrationClockwiseTurn,
                .wheelAngleCalibrationClockwiseSpin,
                .wheelAngleCalibrationCheckStop,
            ]
        }
    }
}
