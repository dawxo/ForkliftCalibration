////  SpinDirectionPicker.swift
//

import SwiftUI

struct SpinDirectionPicker: View {
    @Binding var selection: AngleCorrection.SpinDirection

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private static let segmentShape = RoundedRectangle(cornerRadius: 13)
    private let trackPadding = 4.0
    private let minimumTextScale = 0.7

    var body: some View {
        segmentsLayout {
            segment(.counterclockwise)
            segment(.clockwise)
        }
        .padding(trackPadding)
        .background(Color.controlTrack, in: .rect(cornerRadius: 17))
    }

    private func segment(_ direction: AngleCorrection.SpinDirection) -> some View {
        let isSelected = selection == direction

        return Button {
            selection = direction
        } label: {
            Label(direction.title, systemImage: direction.symbolName)
                .font(.body)
                .fontWeight(isSelected ? .bold : .semibold)
                .foregroundStyle(isSelected ? Color.primaryText : Color.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(isStacked ? nil : 1)
                .minimumScaleFactor(minimumTextScale)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background {
                    if isSelected {
                        Self.segmentShape.fill(Color.cellBackground)
                        Self.segmentShape.strokeBorder(Color.accentText, lineWidth: 2)
                    }
                }
                .contentShape(Self.segmentShape)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var isStacked: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    private var segmentsLayout: AnyLayout {
        isStacked
            ? AnyLayout(VStackLayout(spacing: trackPadding))
            : AnyLayout(HStackLayout(spacing: trackPadding))
    }
}

extension AngleCorrection.SpinDirection {
    var title: LocalizedStringResource {
        switch self {
        case .counterclockwise: .angleCorrectionSpinDirectionCounterclockwise
        case .clockwise: .angleCorrectionSpinDirectionClockwise
        }
    }

    var symbolName: String {
        switch self {
        case .counterclockwise: "arrow.counterclockwise"
        case .clockwise: "arrow.clockwise"
        }
    }
}

#Preview {
    @Previewable @State var selection = AngleCorrection.SpinDirection.counterclockwise

    SpinDirectionPicker(selection: $selection)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
