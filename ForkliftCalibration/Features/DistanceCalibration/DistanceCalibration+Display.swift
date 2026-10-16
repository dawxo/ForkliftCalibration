////  DistanceCalibration+Display.swift
//

import SwiftUI

extension DistanceCalibration {
    static var resultBand: ResultBand {
        ResultBand(
            label: .guideResultLabel,
            content: .instruction(.distanceCalibrationBothWithinLimit)
        )
    }

    var savedCheck: SavedCheck {
        .distanceCalibration(
            left: left,
            right: right,
            leftRightTryCount: leftRightTryCount,
            measured: measured,
            computer: computer,
            magnification: magnification,
            distanceRunTryCount: distanceRunTryCount
        )
    }
}

extension DistanceCalibration.Step {
    var overviewStep: GuideOverviewStep {
        GuideOverviewStep(title: title, detail: .distanceCalibrationOverviewStepDetail)
    }

    var title: LocalizedStringResource {
        switch self {
        case .leftRightCheck: .distanceCalibrationLeftRightCheckTitle
        case .distanceRun: .distanceCalibrationDistanceRunTitle
        }
    }

    var message: LocalizedStringResource {
        switch self {
        case .leftRightCheck: .distanceCalibrationLeftRightCheckMessage
        case .distanceRun: .distanceCalibrationDistanceRunMessage
        }
    }
}
