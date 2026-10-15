////  OffsetView.swift
//

import SwiftUI

struct OffsetView: View {
    private enum Field {
        case value
    }

    @AppStorage("offset.value") private var value = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.offset.title,
            resultBand: ResultBand(label: .offsetResultLabel, content: bandContent),
            focusedField: $focusedField
        ) {
            NumberInputCard(
                label: .offsetFieldValue,
                unit: .unitMeters,
                text: $value,
                isFocused: focusedField == .value
            )
            .focused($focusedField, equals: .value)
        }
    }

    private var bandContent: ResultBand.Content {
        switch Offset.adjustedValue(ParsedNumber(parsing: value)) {
        case .success(let adjustedValue):
            .result(
                value: NumberDisplay.offset(adjustedValue),
                unit: .unitMeters,
                formula: "\(value) − \(NumberDisplay.offset(Offset.subtractedMeters))"
            )
        case .failure(let problem):
            .problem(problem, in: .offsetFieldValue)
        }
    }
}

#Preview {
    NavigationStack {
        OffsetView()
    }
}
