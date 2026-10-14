////  NumberDisplay.swift
//

import Foundation

enum NumberDisplay {
    private static let resultDecimals = 15

    static func result(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(resultDecimals)).grouping(.never))
    }

    static func millimeters(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)).grouping(.never))
    }

    static func adjustment(_ value: Double) -> String {
        value.formatted(.number.sign(strategy: .always()).precision(.fractionLength(4)))
    }
}
