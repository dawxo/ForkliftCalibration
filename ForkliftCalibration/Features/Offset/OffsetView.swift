////  OffsetView.swift
//

import SwiftUI

struct OffsetView: View {
    private enum Field {
        case value
    }

    @AppStorage(SavedInputKey.offsetValue) private var value = ""
    @FocusState private var focusedField: Field?

    var body: some View {
        CalculatorScreen(
            title: CalculatorRoute.offset.title,
            resultBand: Offset.resultBand(value: value),
            savedCheck: savedCheck,
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

    private var savedCheck: SavedCheck? {
        guard case .success = Offset.adjustedValue(ParsedNumber(parsing: value)) else {
            return nil
        }
        return .offset(value: value)
    }
}

extension Offset {
    static func resultBand(value: String) -> ResultBand {
        let content: ResultBand.Content =
            switch adjustedValue(ParsedNumber(parsing: value)) {
            case .success(let result):
                .result(
                    value: NumberDisplay.offset(result),
                    unit: .unitMeters,
                    formula: "\(value) − \(NumberDisplay.offset(subtractedMeters))"
                )
            case .failure(let problem):
                .problem(problem, in: .offsetFieldValue)
            }
        return ResultBand(label: .offsetResultLabel, content: content)
    }
}

#Preview {
    NavigationStack {
        OffsetView()
    }
}
