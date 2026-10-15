////  Offset.swift
//

enum Offset {
    static let subtractedMeters = 0.1

    static func adjustedValue(_ value: ParsedNumber) -> Result<Double, InputProblem> {
        value.nonNegativeValue.map { ($0 - subtractedMeters).roundedToTenDecimalPlaces() }
    }
}
