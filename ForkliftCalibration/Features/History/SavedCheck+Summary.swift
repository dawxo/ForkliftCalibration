////  SavedCheck+Summary.swift
//

import SwiftUI

extension SavedCheck {
    enum Status {
        case pass
        case fail
        case neutral
    }

    struct Summary {
        let status: Status
        let resultLine: LocalizedStringResource
    }

    var route: CalculatorRoute {
        switch self {
        case .angleCorrection: .angleCorrection
        case .leftRightCheck: .leftRightCheck
        case .distanceScale: .distanceScale
        case .offset: .offset
        }
    }

    // Recalculated from the saved inputs, so History uses the same maths as the calculators.
    var summary: Summary {
        switch self {
        case .angleCorrection(_, let spinOutcome, let amount, let wheelbase):
            let outcome = AngleCorrection.calculate(
                spinOutcome: spinOutcome,
                amount: ParsedNumber(parsing: amount),
                wheelbase: ParsedNumber(parsing: wheelbase)
            )
            guard case .calculated(_, let correctedWheelbase) = outcome else {
                return Self.unavailable
            }
            return Summary(
                status: .neutral,
                resultLine: .historyResultWheelbase(NumberDisplay.result(correctedWheelbase))
            )

        case .leftRightCheck(let left, let right):
            let outcome = LeftRightCheck.calculate(
                left: ParsedNumber(parsing: left),
                right: ParsedNumber(parsing: right)
            )
            switch outcome {
            case .within(let differenceMillimeters):
                return Self.limitSummary(differenceMillimeters, isWithinLimit: true)
            case .over(let differenceMillimeters, _):
                return Self.limitSummary(differenceMillimeters, isWithinLimit: false)
            case .problem:
                return Self.unavailable
            }

        case .distanceScale(let measured, let computer, let magnification):
            let outcome = DistanceScale.calculate(
                measured: ParsedNumber(parsing: measured),
                computer: ParsedNumber(parsing: computer),
                magnification: ParsedNumber(parsing: magnification)
            )
            guard case .calculated(let calculation) = outcome else {
                return Self.unavailable
            }
            return Self.limitSummary(
                calculation.differenceMillimeters,
                isWithinLimit: calculation.isWithinLimit
            )

        case .offset(let value):
            let result = Offset.adjustedValue(ParsedNumber(parsing: value))
            guard case .success(let adjustedValue) = result else {
                return Self.unavailable
            }
            return Summary(
                status: .neutral,
                resultLine: .historyResultValue(NumberDisplay.offset(adjustedValue))
            )
        }
    }

    private static let unavailable = Summary(
        status: .neutral,
        resultLine: .historyResultUnavailable
    )

    private static func limitSummary(
        _ differenceMillimeters: Double,
        isWithinLimit: Bool
    ) -> Summary {
        let difference = NumberDisplay.millimeters(abs(differenceMillimeters))
        return isWithinLimit
            ? Summary(status: .pass, resultLine: .historyResultWithinLimit(difference))
            : Summary(status: .fail, resultLine: .historyResultOverLimit(difference))
    }
}
