////  LeftRightCheck.swift
//

enum LeftRightCheck {
    static let limitMillimeters = 5.0
    static let adjustmentStep = 0.0001

    enum Wheel {
        case left
        case right
    }

    enum Outcome {
        case problem(Wheel, InputProblem)
        case within(differenceMillimeters: Double)
        case over(differenceMillimeters: Double, fartherWheel: Wheel)
    }

    static func calculate(left: ParsedNumber, right: ParsedNumber) -> Outcome {
        switch (left.positiveValue, right.positiveValue) {
        case (.success(let leftTravelMeters), .success(let rightTravelMeters)):
            let difference =
                abs(leftTravelMeters - rightTravelMeters).metersToMillimeters().roundedToTenth()
            if difference <= limitMillimeters {
                return .within(differenceMillimeters: difference)
            }
            let fartherWheel: Wheel = leftTravelMeters > rightTravelMeters ? .left : .right
            return .over(differenceMillimeters: difference, fartherWheel: fartherWheel)
        case (.failure(let problem), _):
            return .problem(.left, problem)
        case (_, .failure(let problem)):
            return .problem(.right, problem)
        }
    }

    static func adjustment(for wheel: Wheel, fartherWheel: Wheel) -> Double {
        wheel == fartherWheel ? adjustmentStep : -adjustmentStep
    }
}
