////  LeftRightCheckView.swift
//

import SwiftUI

struct LeftRightCheckView: View {
    @AppStorage("leftRightCheck.left") private var left = ""
    @AppStorage("leftRightCheck.right") private var right = ""
    @FocusState private var focusedField: LeftRightCheck.Wheel?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.leftRightCheck.title,
            resultBand: ResultBand(label: .leftRightCheckResultLabel, content: bandContent),
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

    private var bandContent: ResultBand.Content {
        switch outcome {
        case .within(let differenceMillimeters):
            return differenceResult(
                differenceMillimeters,
                status: .pass(.leftRightCheckStatusWithin)
            )
        case .over(let differenceMillimeters, let fartherWheel):
            return differenceResult(
                differenceMillimeters,
                status: .fail(fartherWheel.wentFartherMessage)
            )
        case .problem(let wheel, let problem):
            return .problem(problem, in: wheel.label)
        }
    }

    private func differenceResult(
        _ differenceMillimeters: Double,
        status: ResultBand.Status
    ) -> ResultBand.Content {
        .result(
            value: NumberDisplay.millimeters(differenceMillimeters),
            unit: .unitMillimeters,
            formula: "\(left) − \(right)",
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
