////  InputProblem.swift
//

nonisolated enum InputProblem: Error {
    case empty
    case notANumber
    case notAboveZero
    case negative
    case aboveMaximum(Double)
}
