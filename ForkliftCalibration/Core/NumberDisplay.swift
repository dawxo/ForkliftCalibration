////  NumberDisplay.swift
//

import Foundation

enum NumberDisplay {
    static func result(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(4)).grouping(.never))
    }

    static func millimeters(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...1)).grouping(.never))
    }
}
