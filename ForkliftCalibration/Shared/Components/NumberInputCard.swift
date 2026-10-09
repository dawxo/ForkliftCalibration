////  NumberInputCard.swift
//

import SwiftUI

struct NumberInputCard: View {
    let label: LocalizedStringResource
    var unit: LocalizedStringResource? = nil
    @Binding var text: String
    var isFocused = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            card

            if isInvalid {
                invalidMessage
            }
        }
    }

    private var card: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.secondaryText)
                    .accessibilityHidden(true)

                HStack(spacing: 8) {
                    TextField(text: $text) { EmptyView() }
                        .keyboardType(.decimalPad)
                        .font(.system(size: valueFontSize, weight: .semibold).monospacedDigit())
                        .foregroundStyle(Color.primaryText)
                        .accessibilityLabel(Text(label))

                    if let unit {
                        Text(unit)
                            .font(.title3)
                            .foregroundStyle(Color.secondaryText)
                    }
                }
            }
            .padding(.vertical, 12)

            if showsClearButton {
                clearButton
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, showsClearButton ? 0 : 20)
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .background(Color.cellBackground, in: Self.shape)
        .overlay {
            if let borderColor {
                Self.shape.strokeBorder(borderColor, lineWidth: 3)
            }
        }
    }

    private static let shape = RoundedRectangle(cornerRadius: 20)

    private var showsClearButton: Bool {
        !text.isEmpty
    }

    private var isInvalid: Bool {
        ParsedNumber(parsing: text) == .notANumber
    }

    private var borderColor: Color? {
        if isInvalid {
            Color.errorText
        } else if isFocused {
            Color.accentText
        } else {
            nil
        }
    }

    private var valueFontSize: CGFloat {
        text.count > 10 ? 22 : 26
    }

    private var clearButton: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.separatorLine)
                .frame(width: 1, height: 40)
                .padding(.leading, 12)

            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(Color.clearButton)
                    .frame(width: 60, height: 72)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text(.inputClear))
        }
    }

    private var invalidMessage: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(.inputInvalid)
        }
        .font(.body)
        .fontWeight(.semibold)
        .foregroundStyle(Color.errorText)
        .padding(.horizontal, 20)
    }
}

#Preview {
    @Previewable @State var measured = "10012"
    @Previewable @State var computer = "10..0"
    @Previewable @State var magnification = "1.421295298592529"

    VStack(spacing: 10) {
        NumberInputCard(
            label: .distanceScaleFieldMeasured,
            unit: .unitMillimeters,
            text: $measured,
            isFocused: true
        )
        NumberInputCard(label: .distanceScaleFieldComputer, unit: .unitMillimeters, text: $computer)
        NumberInputCard(label: .distanceScaleFieldMagnification, text: $magnification)
    }
    .padding(.horizontal, 16)
    .frame(maxHeight: .infinity)
    .background(Color.appBackground)
}
