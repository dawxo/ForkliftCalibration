////  ParsedNumber.swift
//

enum ParsedNumber: Equatable {
    case empty
    case notANumber
    case number(Double)

    init(parsing text: String) {
        if text.isEmpty {
            self = .empty
        } else if let value = Double(text) {
            self = .number(value)
        } else {
            self = .notANumber
        }
    }

    var positiveValue: Result<Double, InputProblem> {
        switch self {
        case .empty: .failure(.empty)
        case .notANumber: .failure(.notANumber)
        case .number(let value) where value > 0: .success(value)
        case .number: .failure(.notAboveZero)
        }
    }

    var nonNegativeValue: Result<Double, InputProblem> {
        switch self {
        case .empty: .failure(.empty)
        case .notANumber: .failure(.notANumber)
        case .number(let value) where value >= 0: .success(value)
        case .number: .failure(.negative)
        }
    }
}
