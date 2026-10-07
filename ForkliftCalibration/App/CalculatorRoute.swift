////  CalculatorRoute.swift
//

import SwiftUI

enum CalculatorRoute {
    case angleCorrection
    case leftRightCheck
    case distanceScale
    case offset
}

extension CalculatorRoute {
    var title: LocalizedStringResource {
        switch self {
        case .angleCorrection: .calculatorAngleCorrectionTitle
        case .leftRightCheck: .calculatorLeftRightCheckTitle
        case .distanceScale: .calculatorDistanceScaleTitle
        case .offset: .calculatorOffsetTitle
        }
    }
}
