////  ResultBand.swift
//

import SwiftUI

struct ResultBand: View {
    enum Content {
        case result(
            value: String,
            unit: LocalizedStringResource? = nil,
            formula: String,
            status: Status? = nil
        )
        case instruction(LocalizedStringResource)
        case error(LocalizedStringResource)
    }

    enum Status {
        case pass(LocalizedStringResource)
        case fail(LocalizedStringResource)
    }

    let label: LocalizedStringResource
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.footnote)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(Color.resultSecondaryText)

            switch content {
            case .result(let value, let unit, let formula, let status):
                result(value: value, unit: unit, formula: formula, status: status)
            case .instruction(let text):
                message(text)
            case .error(let text):
                HStack(spacing: 12) {
                    warningIcon
                    message(text)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .background(Color.resultSurface, ignoresSafeAreaEdges: [])
        .overlay {
            if case .error = content {
                Rectangle()
                    .strokeBorder(Color.resultFail, lineWidth: 3)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }

    @ViewBuilder
    private func result(
        value: String,
        unit: LocalizedStringResource?,
        formula: String,
        status: Status?
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            Text(verbatim: value)
                .font(.system(size: 88, weight: .bold))
                .monospacedDigit()
                .tracking(-2)
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .foregroundStyle(Color.resultPrimaryText)

            if let unit {
                Text(unit)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(Color.resultSecondaryText)
                    .layoutPriority(1)
            }
        }

        Text(verbatim: formula)
            .font(.body.monospaced())
            .foregroundStyle(Color.resultSecondaryText)

        switch status {
        case .pass(let text):
            statusLine(text, systemImage: "checkmark.circle.fill", color: .resultPass)
        case .fail(let text):
            statusLine(text, systemImage: "exclamationmark.triangle.fill", color: .resultFail)
        case nil:
            EmptyView()
        }
    }

    private func statusLine(
        _ text: LocalizedStringResource,
        systemImage: String,
        color: Color
    ) -> some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.resultSurface, color)
            Text(text)
        }
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundStyle(color)
    }

    private func message(_ text: LocalizedStringResource) -> some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color.resultPrimaryText)
            .frame(minHeight: 88, alignment: .leading)
    }

    private var warningIcon: some View {
        Image(systemName: "exclamationmark.triangle.fill")
            .symbolRenderingMode(.palette)
            .foregroundStyle(Color.resultSurface, Color.resultFail)
            .font(.title)
    }
}

extension ResultBand.Content {
    static func problem(_ problem: InputProblem, in fieldLabel: LocalizedStringResource) -> Self {
        let fieldName = String(localized: fieldLabel)

        switch problem {
        case .empty:
            return .instruction(.resultEnter(fieldName))
        case .notANumber:
            return .error(.resultFix(fieldName))
        case .notAboveZero:
            return .error(.resultNotAboveZero(fieldName))
        case .negative:
            return .error(.resultNegative(fieldName))
        }
    }
}

#Preview("Within limit") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .result(
            value: "1.4230",
            formula: "10.002 ÷ 10.000 × 1.421295298592529",
            status: .pass(.distanceScaleStatusWithin)
        )
    )
}

#Preview("Over limit") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .result(
            value: "1.4230",
            formula: "10.012 ÷ 10.000 × 1.421295298592529",
            status: .fail(.distanceScaleStatusOver("12"))
        )
    )
}

#Preview("With unit") {
    ResultBand(
        label: .leftRightCheckResultLabel,
        content: .result(
            value: "8",
            unit: .unitMillimeters,
            formula: "2.003 − 1.995",
            status: .fail(.leftRightCheckStatusLeftFarther)
        )
    )
}

#Preview("Instruction") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .instruction(.resultEnter(String(localized: .distanceScaleFieldMeasured)))
    )
}

#Preview("Error") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .error(.resultFix(String(localized: .distanceScaleFieldComputer)))
    )
}
