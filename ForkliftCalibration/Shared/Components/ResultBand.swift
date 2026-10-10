////  ResultBand.swift
//

import SwiftUI

struct ResultBand: View {
    enum Content {
        case result(value: String, formula: String, status: Status? = nil)
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
            case .result(let value, let formula, let status):
                result(value: value, formula: formula, status: status)
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
    }

    @ViewBuilder
    private func result(value: String, formula: String, status: Status?) -> some View {
        Text(verbatim: value)
            .font(.system(size: 88, weight: .bold))
            .monospacedDigit()
            .tracking(-2)
            .lineLimit(1)
            .minimumScaleFactor(0.3)
            .foregroundStyle(Color.resultPrimaryText)

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

#Preview("Within limit") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .result(
            value: "1.4230",
            formula: "10002 ÷ 10000 × 1.421295298592529",
            status: .pass(.distanceScaleStatusWithin)
        )
    )
}

#Preview("Over limit") {
    ResultBand(
        label: .distanceScaleResultLabel,
        content: .result(
            value: "1.4230",
            formula: "10012 ÷ 10000 × 1.421295298592529",
            status: .fail(.distanceScaleStatusOver("12"))
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
