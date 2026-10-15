////  AngleCorrection.swift
//

enum AngleCorrection {
    static let spinTurns = 10.0
    static let spinDegrees = spinTurns * 360
    static let maximumAmountDegrees = 180.0

    enum SpinDirection: String {
        case counterclockwise
        case clockwise
    }

    enum SpinOutcome {
        case under
        case over
    }

    enum Field {
        case amount
        case wheelbase
    }

    enum Outcome {
        case chooseUnderOrOver
        case problem(Field, InputProblem)
        case calculated(SpinOutcome, correctedWheelbase: Double)
    }

    static func calculate(
        spinOutcome: SpinOutcome?,
        amount: ParsedNumber,
        wheelbase: ParsedNumber
    ) -> Outcome {
        guard let spinOutcome else {
            return .chooseUnderOrOver
        }

        switch (amountDegrees(amount), wheelbase.positiveValue) {
        case (.success(let amountDegrees), .success(let wheelbase)):
            let actualSpinDegrees =
                switch spinOutcome {
                case .under: spinDegrees - amountDegrees
                case .over: spinDegrees + amountDegrees
                }
            return .calculated(
                spinOutcome,
                correctedWheelbase: actualSpinDegrees / spinDegrees * wheelbase
            )
        case (.failure(let problem), _):
            return .problem(.amount, problem)
        case (_, .failure(let problem)):
            return .problem(.wheelbase, problem)
        }
    }

    private static func amountDegrees(_ amount: ParsedNumber) -> Result<Double, InputProblem> {
        amount.positiveValue.flatMap { value in
            value <= maximumAmountDegrees
                ? .success(value)
                : .failure(.aboveMaximum(maximumAmountDegrees))
        }
    }
}
