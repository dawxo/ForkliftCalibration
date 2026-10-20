////  NumberDisplay.swift
//

import Foundation

nonisolated enum NumberDisplay {
    private static let resultMaxDecimals = 15
    private static let offsetMaxDecimals = 10
    private static let trueMinusSign = "\u{2212}"

    static func result(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...resultMaxDecimals)).grouping(.never))
    }

    static func millimeters(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)).grouping(.never))
    }

    static func adjustment(_ value: Double) -> String {
        withTrueMinusSign(
            value.formatted(.number.sign(strategy: .always()).precision(.fractionLength(4)))
        )
    }

    static func offset(_ value: Double) -> String {
        // -0.0 == 0, so this shows negative zero as "0" instead of "-0".
        let displayedValue = value == 0 ? 0 : value
        return withTrueMinusSign(
            displayedValue.formatted(
                .number.precision(.fractionLength(0...offsetMaxDecimals)).grouping(.never)
            )
        )
    }

    private static func withTrueMinusSign(_ text: String) -> String {
        text.replacingOccurrences(of: "-", with: trueMinusSign)
    }
}
