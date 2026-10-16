////  AngleCorrectionView.swift
//

import SwiftUI

struct AngleCorrectionView: View {
    @AppStorage(SavedInputKey.angleCorrectionSpinDirection)
    private var spinDirection = AngleCorrection.SpinDirection.counterclockwise
    @State private var spinOutcome: AngleCorrection.SpinOutcome?
    @AppStorage(SavedInputKey.angleCorrectionAmount) private var amount = ""
    @AppStorage(SavedInputKey.angleCorrectionWheelbase) private var wheelbase = ""
    @FocusState private var focusedField: AngleCorrection.Field?

    init(spinOutcome: AngleCorrection.SpinOutcome? = nil) {
        _spinOutcome = State(initialValue: spinOutcome)
    }

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.angleCorrection.title,
            resultBand: AngleCorrection.resultBand(
                spinOutcome: spinOutcome,
                amount: amount,
                wheelbase: wheelbase
            ),
            savedCheck: savedCheck,
            focusedField: $focusedField
        ) {
            SpinDirectionPicker(selection: $spinDirection)
            SpinPicker(selection: $spinOutcome, spinDirection: spinDirection)

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

    private var savedCheck: SavedCheck? {
        let outcome = AngleCorrection.calculate(
            spinOutcome: spinOutcome,
            amount: ParsedNumber(parsing: amount),
            wheelbase: ParsedNumber(parsing: wheelbase)
        )
        guard case .calculated(let spinOutcome, _) = outcome else {
            return nil
        }
        return .angleCorrection(
            spinDirection: spinDirection,
            spinOutcome: spinOutcome,
            amount: amount,
            wheelbase: wheelbase
        )
    }

}

extension AngleCorrection {
    static func resultBand(
        spinOutcome: SpinOutcome?,
        amount: String,
        wheelbase: String
    ) -> ResultBand {
        let outcome = calculate(
            spinOutcome: spinOutcome,
            amount: ParsedNumber(parsing: amount),
            wheelbase: ParsedNumber(parsing: wheelbase)
        )
        let content: ResultBand.Content =
            switch outcome {
            case .chooseUnderOrOver:
                .instruction(.angleCorrectionResultChooseUnderOrOver)
            case .problem(let field, let problem):
                .problem(problem, in: field.label)
            case .calculated(let spinOutcome, let correctedWheelbase):
                .result(
                    value: NumberDisplay.result(correctedWheelbase),
                    formula: formula(for: spinOutcome, amount: amount, wheelbase: wheelbase)
                )
            }
        return ResultBand(label: .angleCorrectionResultLabel, content: content)
    }

    private static func formula(
        for spinOutcome: SpinOutcome,
        amount: String,
        wheelbase: String
    ) -> String {
        let fullSpin = spinDegrees.formatted(.number.grouping(.never))
        let operation =
            switch spinOutcome {
            case .under: "−"
            case .over: "+"
            }
        return "(\(fullSpin) \(operation) \(amount)) ÷ \(fullSpin) × \(wheelbase)"
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

extension AngleCorrection.SpinOutcome: SpinPickerOption {
    var title: LocalizedStringResource {
        switch self {
        case .under: .angleCorrectionSpinOutcomeUnder
        case .over: .angleCorrectionSpinOutcomeOver
        }
    }

    var caption: LocalizedStringResource {
        switch self {
        case .under: .angleCorrectionSpinOutcomeStoppedShort
        case .over: .angleCorrectionSpinOutcomeWentPast
        }
    }

    func diagram(isSelected: Bool) -> ImageResource {
        switch (self, isSelected) {
        case (.under, false): .angleUnder
        case (.under, true): .angleUnderSelected
        case (.over, false): .angleOver
        case (.over, true): .angleOverSelected
        }
    }
}

#Preview {
    NavigationStack {
        AngleCorrectionView()
    }
}
