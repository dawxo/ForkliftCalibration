////  GuideConfirmCard.swift
//

import SwiftUI

struct GuideConfirmCard: View {
    let label: LocalizedStringResource
    @Binding var isConfirmed: Bool

    @ScaledMetric(relativeTo: .title3) private var checkboxSize = 36.0

    private static let checkboxShape = RoundedRectangle(cornerRadius: 10)

    var body: some View {
        Button {
            isConfirmed.toggle()
        } label: {
            HStack(spacing: 16) {
                checkbox

                Text(label)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(minHeight: 80)
            .background(Color.cellBackground, in: .rect(cornerRadius: 20))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isConfirmed ? .isSelected : [])
    }

    private var checkbox: some View {
        ZStack {
            if isConfirmed {
                Self.checkboxShape
                    .fill(Color.accentFill)
                Image(systemName: "checkmark")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.onAccent)
            } else {
                Self.checkboxShape
                    .strokeBorder(Color.separatorLine, lineWidth: 2)
            }
        }
        .frame(width: checkboxSize, height: checkboxSize)
    }
}

#Preview {
    @Previewable @State var isConfirmed = true

    GuideConfirmCard(label: .wheelAngleCalibrationBound, isConfirmed: $isConfirmed)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
