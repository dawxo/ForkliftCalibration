////  DistanceScaleView.swift
//

import SwiftUI

struct DistanceScaleView: View {
    @AppStorage(SavedInputKey.distanceScaleMeasured) private var measured = ""
    @AppStorage(SavedInputKey.distanceScaleComputer) private var computer = ""
    @AppStorage(SavedInputKey.distanceScaleMagnification) private var magnification = ""
    @FocusState private var focusedField: DistanceScale.Field?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.distanceScale.title,
            resultBand: DistanceScale.resultBand(
                measured: measured,
                computer: computer,
                magnification: magnification
            ),
            savedCheck: savedCheck,
            focusedField: $focusedField
        ) {
            HowToMeasureButton(thumbnail: .distanceRun, subtitle: .distanceScaleHowToSubtitle) {
                DistanceScaleHowToMeasureSheet()
            }

            inputCard(.measured, text: $measured, unit: .unitMeters)
            inputCard(.computer, text: $computer, unit: .unitMeters)
            inputCard(.magnification, text: $magnification)
        }
    }

    private func inputCard(
        _ field: DistanceScale.Field,
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
        let outcome = DistanceScale.calculate(
            measured: ParsedNumber(parsing: measured),
            computer: ParsedNumber(parsing: computer),
            magnification: ParsedNumber(parsing: magnification)
        )
        guard case .calculated = outcome else {
            return nil
        }
        return .distanceScale(measured: measured, computer: computer, magnification: magnification)
    }
}

extension DistanceScale {
    static func resultBand(
        measured: String,
        computer: String,
        magnification: String
    ) -> ResultBand {
        let outcome = calculate(
            measured: ParsedNumber(parsing: measured),
            computer: ParsedNumber(parsing: computer),
            magnification: ParsedNumber(parsing: magnification)
        )
        let content: ResultBand.Content =
            switch outcome {
            case .calculated(let calculation):
                .result(
                    value: NumberDisplay.result(calculation.correctedMagnification),
                    formula: "\(measured) ÷ \(computer) × \(magnification)",
                    status: status(for: calculation)
                )
            case .problem(let field, let problem):
                .problem(problem, in: field.label)
            }
        return ResultBand(label: .distanceScaleResultLabel, content: content)
    }

    private static func status(for calculation: Calculation) -> ResultBand.Status {
        if calculation.isWithinLimit {
            return .pass(.distanceScaleStatusWithin)
        }
        let difference = NumberDisplay.millimeters(abs(calculation.differenceMillimeters))
        return .fail(.distanceScaleStatusOver(difference))
    }
}

extension DistanceScale.Field {
    var label: LocalizedStringResource {
        switch self {
        case .measured: .distanceScaleFieldMeasured
        case .computer: .distanceScaleFieldComputer
        case .magnification: .distanceScaleFieldMagnification
        }
    }
}

#Preview {
    NavigationStack {
        DistanceScaleView()
    }
}
