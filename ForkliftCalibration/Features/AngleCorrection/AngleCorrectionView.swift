////  AngleCorrectionView.swift
//

import SwiftUI

struct AngleCorrectionView: View {
    @AppStorage("angleCorrection.spinDirection")
    private var spinDirection = AngleCorrection.SpinDirection.counterclockwise
    @State private var spinOutcome: AngleCorrection.SpinOutcome?
    @AppStorage("angleCorrection.amount") private var amount = ""
    @AppStorage("angleCorrection.wheelbase") private var wheelbase = ""
    @FocusState private var focusedField: AngleCorrection.Field?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.angleCorrection.title,
            resultBand: ResultBand(label: .angleCorrectionResultLabel, content: bandContent),
            focusedField: $focusedField
        ) {
            SpinDirectionPicker(selection: $spinDirection)
            SpinOutcomePicker(selection: $spinOutcome, spinDirection: spinDirection)

            inputCard(.amount, text: $amount, unit: .unitDegrees)
            inputCard(.wheelbase, text: $wheelbase)
        }
    }

    private func inputCard(
        _ field: AngleCorrection.Field,
        text: Binding<String>,
        unit: LocalizedStringResource? = nil
    ) -> some View {
        NumberInputCard(
            label: field.label,
            unit: unit,
            text: text,
            isFocused: focusedField == field
        )
        .focused($focusedField, equals: field)
    }

    private var bandContent: ResultBand.Content {
        let outcome = AngleCorrection.calculate(
            spinOutcome: spinOutcome,
            amount: ParsedNumber(parsing: amount),
            wheelbase: ParsedNumber(parsing: wheelbase)
        )

        switch outcome {
        case .chooseUnderOrOver:
            return .instruction(.angleCorrectionResultChooseUnderOrOver)
        case .problem(let field, let problem):
            return .problem(problem, in: field.label)
        case .calculated(let spinOutcome, let correctedWheelbase):
            return .result(
                value: NumberDisplay.result(correctedWheelbase),
                formula: formula(for: spinOutcome)
            )
        }
    }

    private func formula(for spinOutcome: AngleCorrection.SpinOutcome) -> String {
        let spinDegrees = AngleCorrection.spinDegrees.formatted(.number.grouping(.never))
        let operation =
            switch spinOutcome {
            case .under: "−"
            case .over: "+"
            }
        return "(\(spinDegrees) \(operation) \(amount)) ÷ \(spinDegrees) × \(wheelbase)"
    }
}

extension AngleCorrection.Field {
    var label: LocalizedStringResource {
        switch self {
        case .amount: .angleCorrectionFieldAmount
        case .wheelbase: .angleCorrectionFieldWheelbase
        }
    }
}

#Preview {
    NavigationStack {
        AngleCorrectionView()
    }
}
