////  DistanceScaleView.swift
//

import SwiftUI

struct DistanceScaleView: View {
    @State private var measured = ""
    @State private var computer = ""
    @State private var magnification = ""
    @FocusState private var focusedField: DistanceScale.Field?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                inputCard(.measured, text: $measured, unit: .unitMillimeters)
                inputCard(.computer, text: $computer, unit: .unitMillimeters)

                Text(.distanceScaleFieldMagnification)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .textCase(.uppercase)
                    .foregroundStyle(Color.secondaryText)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                inputCard(.magnification, text: $magnification)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .scrollDismissesKeyboard(.interactively)
        .onTapGesture {
            focusedField = nil
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            ResultBand(label: .distanceScaleResultLabel, content: bandContent)
        }
        .background(Color.appBackground)
        .navigationTitle(CalculatorRoute.distanceScale.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button(.keyboardDone) {
                    focusedField = nil
                }
                .fontWeight(.semibold)
            }
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
            return message(for: problem, in: field)
        }
    }

    private func status(for calculation: DistanceScale.Calculation) -> ResultBand.Status {
        if calculation.isWithinLimit {
            return .pass(.distanceScaleStatusWithin)
        }
        let difference = NumberDisplay.millimeters(abs(calculation.differenceMillimeters))
        return .fail(.distanceScaleStatusOver(difference))
    }

    private func message(
        for problem: InputProblem,
        in field: DistanceScale.Field
    ) -> ResultBand.Content {
        let fieldName = String(localized: field.label)

        switch problem {
        case .empty:
            return .instruction(.resultEnter(fieldName))
        case .notANumber:
            return .error(.resultFix(fieldName))
        case .notAboveZero:
            return .error(.resultNotAboveZero(fieldName))
        }
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
