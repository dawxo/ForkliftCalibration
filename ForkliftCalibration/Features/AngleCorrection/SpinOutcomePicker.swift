////  SpinOutcomePicker.swift
//

import SwiftUI

struct SpinOutcomePicker: View {
    @Binding var selection: AngleCorrection.SpinOutcome?
    let spinDirection: AngleCorrection.SpinDirection

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private static let shape = RoundedRectangle(cornerRadius: 18)
    private let buttonSpacing = 10.0
    private let legendIconWidth = 26.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            buttonsLayout {
                optionButton(.under)
                optionButton(.over)
            }

            if !isStacked {
                legend
            }
        }
    }

    private func optionButton(_ spinOutcome: AngleCorrection.SpinOutcome) -> some View {
        let isSelected = selection == spinOutcome

        return Button {
            selection = spinOutcome
        } label: {
            VStack(spacing: 4) {
                if !isStacked {
                    diagram(for: spinOutcome, isSelected: isSelected)
                }

                HStack(spacing: 6) {
                    if isSelected {
                        Image(systemName: "checkmark")
                    }
                    Text(spinOutcome.title)
                }
                .font(.title2)
                .fontWeight(isSelected ? .bold : .semibold)
                .foregroundStyle(isSelected ? Color.onAccent : Color.primaryText)

                Text(spinOutcome.caption)
                    .font(.subheadline)
                    .foregroundStyle(isSelected ? Color.onAccent : Color.secondaryText)
            }
            .multilineTextAlignment(.center)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 116)
            .background(isSelected ? Color.accentFill : Color.cellBackground, in: Self.shape)
            .overlay {
                if !isSelected {
                    Self.shape.strokeBorder(Color.separatorLine, lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func diagram(
        for spinOutcome: AngleCorrection.SpinOutcome,
        isSelected: Bool
    ) -> some View {
        Image(spinOutcome.diagram(isSelected: isSelected))
            .scaleEffect(y: spinDirection == .clockwise ? -1 : 1)
            .accessibilityHidden(true)
    }

    private var legend: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 14) { legendItems }
            VStack(alignment: .leading, spacing: 6) { legendItems }
        }
        .font(.footnote)
        .foregroundStyle(Color.secondaryText)
        .padding(.horizontal, 12)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var legendItems: some View {
        legendItem(
            .angleCorrectionLegendZeroLine,
            lineColor: .secondaryText,
            lineLength: 20,
            lineThickness: 3
        )
        legendItem(
            .angleCorrectionLegendOffset,
            lineColor: .accentText,
            lineLength: 18,
            lineThickness: 5
        )
    }

    private func legendItem(
        _ title: LocalizedStringResource,
        lineColor: Color,
        lineLength: CGFloat,
        lineThickness: CGFloat
    ) -> some View {
        HStack(spacing: 8) {
            Capsule()
                .fill(lineColor)
                .frame(width: lineLength, height: lineThickness)
                .frame(width: legendIconWidth)
            Text(title)
        }
    }

    private var isStacked: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    private var buttonsLayout: AnyLayout {
        isStacked
            ? AnyLayout(VStackLayout(spacing: buttonSpacing))
            : AnyLayout(HStackLayout(spacing: buttonSpacing))
    }
}

extension AngleCorrection.SpinOutcome {
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
    @Previewable @State var selection: AngleCorrection.SpinOutcome? = .under

    SpinOutcomePicker(selection: $selection, spinDirection: .counterclockwise)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
