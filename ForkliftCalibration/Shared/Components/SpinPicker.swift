////  SpinPicker.swift
//

import SwiftUI

protocol SpinPickerOption: CaseIterable, Hashable where AllCases == [Self] {
    var title: LocalizedStringResource { get }
    var caption: LocalizedStringResource { get }

    func diagram(isSelected: Bool) -> ImageResource
}

struct SpinPicker<Option: SpinPickerOption>: View {
    @Binding var selection: Option?
    let spinDirection: AngleCorrection.SpinDirection

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private static var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 18) }
    private let buttonSpacing = 10.0
    private let legendIconWidth = 26.0
    private let diagramMaxWidth = 128.0

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            buttonsLayout {
                ForEach(Option.allCases, id: \.self) { option in
                    optionButton(option)
                }
            }

            if !isStacked {
                legend
            }
        }
    }

    private func optionButton(_ option: Option) -> some View {
        let isSelected = selection == option

        return Button {
            selection = option
        } label: {
            VStack(spacing: 4) {
                if !isStacked {
                    diagram(for: option, isSelected: isSelected)
                }

                HStack(spacing: 6) {
                    if isSelected {
                        Image(systemName: "checkmark")
                    }
                    Text(option.title)
                }
                .font(.title2)
                .fontWeight(isSelected ? .bold : .semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(isSelected ? Color.onAccent : Color.primaryText)

                Text(option.caption)
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

    private func diagram(for option: Option, isSelected: Bool) -> some View {
        Image(option.diagram(isSelected: isSelected))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: diagramMaxWidth)
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

#Preview {
    @Previewable @State var selection: AngleCorrection.SpinOutcome? = .under

    SpinPicker(selection: $selection, spinDirection: .counterclockwise)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
