////  SavedCheck+Detail.swift
//

import SwiftUI

extension SavedCheck {
    struct InputRow {
        enum Value {
            case number(String, unit: LocalizedStringResource?)
            case choice(LocalizedStringResource)
        }

        let label: LocalizedStringResource
        let value: Value
    }

    var resultBand: ResultBand {
        switch self {
        case .angleCorrection(_, let spinOutcome, let amount, let wheelbase):
            AngleCorrection.resultBand(
                spinOutcome: spinOutcome,
                amount: amount,
                wheelbase: wheelbase
            )
        case .leftRightCheck(let left, let right):
            LeftRightCheck.resultBand(left: left, right: right)
        case .distanceScale(let measured, let computer, let magnification):
            DistanceScale.resultBand(
                measured: measured,
                computer: computer,
                magnification: magnification
            )
        case .offset(let value):
            Offset.resultBand(value: value)
        case .wheelAngleCalibration(let counterclockwise, let clockwise, let amount, let wheelbase):
            WheelAngleCalibration(
                counterclockwise: counterclockwise,
                clockwise: clockwise,
                amount: amount,
                wheelbase: wheelbase
            )
            .resultBand
        }
    }

    var inputRows: [InputRow] {
        switch self {
        case .angleCorrection(let spinDirection, let spinOutcome, let amount, let wheelbase):
            [
                InputRow(label: .historyDetailDirection, value: .choice(spinDirection.title)),
                InputRow(label: .historyDetailSpin, value: .choice(spinOutcome.title)),
                InputRow(
                    label: AngleCorrection.Field.amount.label,
                    value: .number(amount, unit: .unitDegrees)
                ),
                InputRow(
                    label: AngleCorrection.Field.wheelbase.label,
                    value: .number(wheelbase, unit: nil)
                ),
            ]
        case .leftRightCheck(let left, let right):
            [
                InputRow(
                    label: LeftRightCheck.Wheel.left.label,
                    value: .number(left, unit: .unitMeters)
                ),
                InputRow(
                    label: LeftRightCheck.Wheel.right.label,
                    value: .number(right, unit: .unitMeters)
                ),
            ]
        case .distanceScale(let measured, let computer, let magnification):
            [
                InputRow(
                    label: DistanceScale.Field.measured.label,
                    value: .number(measured, unit: .unitMeters)
                ),
                InputRow(
                    label: DistanceScale.Field.computer.label,
                    value: .number(computer, unit: .unitMeters)
                ),
                InputRow(
                    label: DistanceScale.Field.magnification.label,
                    value: .number(magnification, unit: nil)
                ),
            ]
        case .offset(let value):
            [InputRow(label: .offsetFieldValue, value: .number(value, unit: .unitMeters))]
        case .wheelAngleCalibration(let counterclockwise, let clockwise, let amount, let wheelbase):
            Self.wheelAngleCalibrationRows(
                counterclockwise: counterclockwise,
                clockwise: clockwise,
                amount: amount,
                wheelbase: wheelbase
            )
        }
    }

    private static func wheelAngleCalibrationRows(
        counterclockwise: WheelAngleCalibration.SpinResult,
        clockwise: WheelAngleCalibration.SpinResult,
        amount: String,
        wheelbase: String
    ) -> [InputRow] {
        let spinRows = [
            InputRow(
                label: AngleCorrection.SpinDirection.counterclockwise.title,
                value: .choice(counterclockwise.title)
            ),
            InputRow(
                label: AngleCorrection.SpinDirection.clockwise.title,
                value: .choice(clockwise.title)
            ),
        ]
        guard !amount.isEmpty else {
            return spinRows
        }
        return spinRows + [
            InputRow(
                label: AngleCorrection.Field.amount.label,
                value: .number(amount, unit: .unitDegrees)
            ),
            InputRow(
                label: AngleCorrection.Field.wheelbase.label,
                value: .number(wheelbase, unit: nil)
            ),
        ]
    }

    var restoresIntoCalculator: Bool {
        switch self {
        case .angleCorrection, .leftRightCheck, .distanceScale, .offset: true
        case .wheelAngleCalibration: false
        }
    }

    // Writes the inputs where each calculator reads its saved values. Angle Correction's
    // Under/Over choice isn't saved there, so it's passed to the screen instead.
    func restoreInputs() {
        let defaults = UserDefaults.standard
        switch self {
        case .angleCorrection(let spinDirection, _, let amount, let wheelbase):
            defaults.set(spinDirection.rawValue, forKey: SavedInputKey.angleCorrectionSpinDirection)
            defaults.set(amount, forKey: SavedInputKey.angleCorrectionAmount)
            defaults.set(wheelbase, forKey: SavedInputKey.angleCorrectionWheelbase)
        case .leftRightCheck(let left, let right):
            defaults.set(left, forKey: SavedInputKey.leftRightCheckLeft)
            defaults.set(right, forKey: SavedInputKey.leftRightCheckRight)
        case .distanceScale(let measured, let computer, let magnification):
            defaults.set(measured, forKey: SavedInputKey.distanceScaleMeasured)
            defaults.set(computer, forKey: SavedInputKey.distanceScaleComputer)
            defaults.set(magnification, forKey: SavedInputKey.distanceScaleMagnification)
        case .offset(let value):
            defaults.set(value, forKey: SavedInputKey.offsetValue)
        case .wheelAngleCalibration:
            break
        }
    }
}
