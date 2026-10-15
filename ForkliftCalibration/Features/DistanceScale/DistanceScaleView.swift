////  DistanceScaleView.swift
//

import SwiftUI

struct DistanceScaleView: View {
    @AppStorage("distanceScale.measured") private var measured = ""
    @AppStorage("distanceScale.computer") private var computer = ""
    @AppStorage("distanceScale.magnification") private var magnification = ""
    @FocusState private var focusedField: DistanceScale.Field?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.distanceScale.title,
            resultBand: ResultBand(label: .distanceScaleResultLabel, content: bandContent),
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

    private var bandContent: ResultBand.Content {
        let outcome = DistanceScale.calculate(
            measured: ParsedNumber(parsing: measured),
            computer: ParsedNumber(parsing: computer),
            magnification: ParsedNumber(parsing: magnification)
        )

        switch outcome {
        case .calculated(let calculation):
            return .result(
                value: NumberDisplay.result(calculation.correctedMagnification),
                formula: "\(measured) ÷ \(computer) × \(magnification)",
                status: status(for: calculation)
            )
        case .problem(let field, let problem):
            return .problem(problem, in: field.label)
        }
    }

    private func status(for calculation: DistanceScale.Calculation) -> ResultBand.Status {
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
