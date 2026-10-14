////  LeftRightHowToMeasureSheet.swift
//

import SwiftUI

struct LeftRightHowToMeasureSheet: View {
    var body: some View {
        HowToMeasureSheet(steps: [
            .leftRightCheckHowToStep1,
            .leftRightCheckHowToStep2,
            .leftRightCheckHowToStep3,
            .leftRightCheckHowToStep4,
        ]) {
            VStack(spacing: 8) {
                wheelLabel(.leftRightCheckFieldLeft)

                Image(.leftRightRun)
                    .resizable()
                    .scaledToFit()

                wheelLabel(.leftRightCheckFieldRight)
            }
            .accessibilityHidden(true)
        }
    }

    private func wheelLabel(_ text: LocalizedStringResource) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundStyle(Color.accentText)
    }
}

#Preview {
    Color.appBackground
        .sheet(isPresented: .constant(true)) {
            LeftRightHowToMeasureSheet()
        }
}
