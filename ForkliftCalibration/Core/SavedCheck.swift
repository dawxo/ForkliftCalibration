////  SavedCheck.swift
//

nonisolated enum SavedCheck: Codable, Equatable {
    case angleCorrection(
        spinDirection: AngleCorrection.SpinDirection,
        spinOutcome: AngleCorrection.SpinOutcome,
        amount: String,
        wheelbase: String
    )
    case leftRightCheck(left: String, right: String)
    case distanceScale(measured: String, computer: String, magnification: String)
    case offset(value: String)
    case wheelAngleCalibration(
        counterclockwise: WheelAngleCalibration.SpinResult,
        clockwise: WheelAngleCalibration.SpinResult,
        amount: String,
        wheelbase: String
    )
    case distanceCalibration(
        left: String,
        right: String,
        leftRightTryCount: Int,
        measured: String,
        computer: String,
        magnification: String,
        distanceRunTryCount: Int
    )
}
