////  LeftRightCheckView.swift
//

import SwiftUI

struct LeftRightCheckView: View {
    @AppStorage(SavedInputKey.leftRightCheckLeft) private var left = ""
    @AppStorage(SavedInputKey.leftRightCheckRight) private var right = ""
    @FocusState private var focusedField: LeftRightCheck.Wheel?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.leftRightCheck.title,
            resultBand: LeftRightCheck.resultBand(left: left, right: right),
            savedCheck: savedCheck,
            focusedField: $focusedField
        ) {
            switch outcome {
            case .over(_, let fartherWheel):
                LeftRightAdjustCard(fartherWheel: fartherWheel)
            case .within:
                nextButton
            case .problem:
                EmptyView()
            }

            HowToMeasureButton(thumbnail: .leftRightRun, subtitle: .leftRightCheckHowToSubtitle) {
                LeftRightHowToMeasureSheet()
            }

            inputCard(.left, text: $left)
            inputCard(.right, text: $right)
        }
    }

    private var nextButton: some View {
        NavigationLink(value: CalculatorRoute.distanceScale) {
            HStack(spacing: 10) {
                Text(.leftRightCheckNext)
                Image(systemName: "chevron.forward")
                    .accessibilityHidden(true)
            }
        }
        .buttonStyle(.primary)
    }

    private func inputCard(_ wheel: LeftRightCheck.Wheel, text: Binding<String>) -> some View {
        NumberInputCard(
            label: wheel.label,
            unit: .unitMeters,
            text: text,
            isFocused: focusedField == wheel
        )
        .focused($focusedField, equals: wheel)
    }

    private var outcome: LeftRightCheck.Outcome {
        LeftRightCheck.calculate(
            left: ParsedNumber(parsing: left),
            right: ParsedNumber(parsing: right)
        )
    }

    private var savedCheck: SavedCheck? {
        switch outcome {
        case .within, .over: .leftRightCheck(left: left, right: right)
        case .problem: nil
        }
    }

}

extension LeftRightCheck {
    static func resultBand(left: String, right: String) -> ResultBand {
        let outcome = calculate(
            left: ParsedNumber(parsing: left),
            right: ParsedNumber(parsing: right)
        )
        let content: ResultBand.Content =
            switch outcome {
            case .within(let differenceMillimeters):
                differenceResult(
                    differenceMillimeters,
                    formula: "\(left) − \(right)",
                    status: .pass(.leftRightCheckStatusWithin)
                )
            case .over(let differenceMillimeters, let fartherWheel):
                differenceResult(
                    differenceMillimeters,
                    formula: "\(left) − \(right)",
                    status: .fail(fartherWheel.wentFartherMessage)
                )
            case .problem(let wheel, let problem):
                .problem(problem, in: wheel.label)
            }
        return ResultBand(label: .leftRightCheckResultLabel, content: content)
    }

    private static func differenceResult(
        _ differenceMillimeters: Double,
        formula: String,
        status: ResultBand.Status
    ) -> ResultBand.Content {
        .result(
            value: NumberDisplay.millimeters(differenceMillimeters),
            unit: .unitMillimeters,
            formula: formula,
            status: status
        )
    }
}

extension LeftRightCheck.Wheel {
    var label: LocalizedStringResource {
        switch self {
        case .left: .leftRightCheckFieldLeft
        case .right: .leftRightCheckFieldRight
        }
    }

    var wentFartherMessage: LocalizedStringResource {
        switch self {
        case .left: .leftRightCheckStatusLeftFarther
        case .right: .leftRightCheckStatusRightFarther
        }
    }
}

#Preview {
    NavigationStack {
        LeftRightCheckView()
    }
}
