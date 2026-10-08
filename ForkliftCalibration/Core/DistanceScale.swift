////  DistanceScale.swift
//

enum DistanceScale {
    static let limitMillimeters = 5.0

    enum Field {
        case measured
        case computer
        case magnification
    }

    enum Outcome {
        case problem(Field, InputProblem)
        case calculated(Calculation)
    }

    struct Calculation {
        let correctedMagnification: Double
        let differenceMillimeters: Double

        init(measured: Double, computer: Double, magnification: Double) {
            correctedMagnification = measured / computer * magnification
            differenceMillimeters = measured - computer
        }

        var isWithinLimit: Bool {
            abs(differenceMillimeters) <= DistanceScale.limitMillimeters + 1e-9
        }
    }

    static func calculate(
        measured: ParsedNumber,
        computer: ParsedNumber,
        magnification: ParsedNumber
    ) -> Outcome {
        switch (measured.positiveValue, computer.positiveValue, magnification.positiveValue) {
        case (.success(let measured), .success(let computer), .success(let magnification)):
            .calculated(
                Calculation(measured: measured, computer: computer, magnification: magnification))
        case (.failure(let problem), _, _): .problem(.measured, problem)
        case (_, .failure(let problem), _): .problem(.computer, problem)
        case (_, _, .failure(let problem)): .problem(.magnification, problem)
        }
    }
}
