////  DistanceCalibration.swift
//

struct DistanceCalibration: Guide, Codable, Equatable {
    enum Step: Codable, CaseIterable, Comparable {
        case leftRightCheck
        case distanceRun
    }

    var currentStep = Step.leftRightCheck
    var left = ""
    var right = ""
    var leftRightTryCount = 1
    var measured = ""
    var computer = ""
    var magnification = ""
    var distanceRunTryCount = 1
}

extension DistanceCalibration {
    var leftRightOutcome: LeftRightCheck.Outcome {
        LeftRightCheck.calculate(
            left: ParsedNumber(parsing: left),
            right: ParsedNumber(parsing: right)
        )
    }

    var distanceRunOutcome: DistanceScale.Outcome {
        DistanceScale.calculate(
            measured: ParsedNumber(parsing: measured),
            computer: ParsedNumber(parsing: computer),
            magnification: ParsedNumber(parsing: magnification)
        )
    }

    var canContinue: Bool {
        switch currentStep {
        case .leftRightCheck: leftRightDifferenceMillimeters != nil
        case .distanceRun: distanceRunDifferenceMillimeters != nil
        }
    }

    func isSkipped(_ step: Step) -> Bool {
        false
    }

    var needsAnotherRun: Bool {
        switch currentStep {
        case .leftRightCheck:
            guard case .over = leftRightOutcome else {
                return false
            }
            return true
        case .distanceRun:
            guard case .calculated(let calculation) = distanceRunOutcome else {
                return false
            }
            return !calculation.isWithinLimit
        }
    }

    var leftRightDifferenceMillimeters: Double? {
        switch leftRightOutcome {
        case .within(let differenceMillimeters), .over(let differenceMillimeters, _):
            differenceMillimeters
        case .problem:
            nil
        }
    }

    var distanceRunDifferenceMillimeters: Double? {
        guard case .calculated(let calculation) = distanceRunOutcome else {
            return nil
        }
        return abs(calculation.differenceMillimeters)
    }

    var currentTryCount: Int {
        switch currentStep {
        case .leftRightCheck: leftRightTryCount
        case .distanceRun: distanceRunTryCount
        }
    }

    mutating func startAnotherRun() {
        switch currentStep {
        case .leftRightCheck:
            left = ""
            right = ""
            leftRightTryCount += 1
        case .distanceRun:
            guard case .calculated(let calculation) = distanceRunOutcome else {
                return
            }
            magnification = String(calculation.correctedMagnification)
            measured = ""
            computer = ""
            distanceRunTryCount += 1
        }
    }
}
