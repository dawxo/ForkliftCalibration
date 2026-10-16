////  WheelAngleCalibration.swift
//

struct WheelAngleCalibration: Guide, Codable, Equatable {
    enum Step: Codable, CaseIterable, Comparable {
        case bind
        case spinCounterclockwise
        case bindAgain
        case spinClockwise
        case correctWheelbase
    }

    nonisolated enum SpinResult: String, Codable, CaseIterable {
        case withinLimit
        case under
        case over
    }

    var currentStep = Step.bind
    var isBound = false
    var isBoundAgain = false
    var counterclockwise: SpinResult?
    var clockwise: SpinResult?
    var amount = ""
    var wheelbase = ""
}

extension WheelAngleCalibration {
    var canContinue: Bool {
        switch currentStep {
        case .bind: isBound
        case .spinCounterclockwise: counterclockwise != nil
        case .bindAgain: isBoundAgain
        case .spinClockwise: clockwise != nil
        case .correctWheelbase: correctedWheelbase != nil
        }
    }

    func isSkipped(_ step: Step) -> Bool {
        step == .correctWheelbase && counterclockwise == .withinLimit && clockwise == .withinLimit
    }

    var correctedSpinDirection: AngleCorrection.SpinDirection? {
        if counterclockwise?.spinOutcome != nil {
            .counterclockwise
        } else if clockwise?.spinOutcome != nil {
            .clockwise
        } else {
            nil
        }
    }

    var correctedSpinOutcome: AngleCorrection.SpinOutcome? {
        switch correctedSpinDirection {
        case .counterclockwise: counterclockwise?.spinOutcome
        case .clockwise: clockwise?.spinOutcome
        case nil: nil
        }
    }

    var correction: AngleCorrection.Outcome {
        AngleCorrection.calculate(
            spinOutcome: correctedSpinOutcome,
            amount: ParsedNumber(parsing: amount),
            wheelbase: ParsedNumber(parsing: wheelbase)
        )
    }

    var correctedWheelbase: Double? {
        guard case .calculated(_, let correctedWheelbase) = correction else {
            return nil
        }
        return correctedWheelbase
    }
}

extension WheelAngleCalibration.SpinResult {
    var spinOutcome: AngleCorrection.SpinOutcome? {
        switch self {
        case .withinLimit: nil
        case .under: .under
        case .over: .over
        }
    }
}
