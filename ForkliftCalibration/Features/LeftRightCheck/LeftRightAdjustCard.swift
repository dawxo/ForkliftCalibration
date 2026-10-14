////  LeftRightAdjustCard.swift
//

import SwiftUI

struct LeftRightAdjustCard: View {
    let fartherWheel: LeftRightCheck.Wheel

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private let itemSpacing = 14.0
    private let sideInset = 20.0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(.leftRightCheckAdjustTitle)
                .font(.footnote)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(0.6)
                .foregroundStyle(Color.secondaryText)
                .padding(.top, 14)
                .padding(.bottom, 4)
                .padding(.horizontal, sideInset)

            adjustmentRow(.left)

            Rectangle()
                .fill(Color.separatorLine)
                .frame(height: 1)

            adjustmentRow(.right)
        }
        .background(Color.cellBackground, in: .rect(cornerRadius: 20))
    }

    private func adjustmentRow(_ wheel: LeftRightCheck.Wheel) -> some View {
        let amount = LeftRightCheck.adjustment(for: wheel, fartherWheel: fartherWheel)

        return HStack(spacing: itemSpacing) {
            Image(systemName: amount > 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .font(.largeTitle)
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.onAccent, Color.accentFill)
                .accessibilityHidden(true)

            nameAndAmountLayout {
                Text(wheel.label)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(verbatim: NumberDisplay.adjustment(amount))
                    .font(.system(size: 30, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(Color.primaryText)
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, sideInset)
        .frame(minHeight: 68)
        .accessibilityElement(children: .combine)
    }

    private var nameAndAmountLayout: AnyLayout {
        dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4))
            : AnyLayout(HStackLayout(spacing: itemSpacing))
    }
}

#Preview {
    LeftRightAdjustCard(fartherWheel: .left)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
