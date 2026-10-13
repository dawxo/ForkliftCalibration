////  DistanceScaleHowToMeasureSheet.swift
//

import SwiftUI

struct DistanceScaleHowToMeasureSheet: View {
    var body: some View {
        HowToMeasureSheet(steps: [
            .distanceScaleHowToStep1,
            .distanceScaleHowToStep2,
            .distanceScaleHowToStep3,
            .distanceScaleHowToStep4,
        ]) {
            VStack(spacing: 8) {
                Text(.distanceScaleHowToComputerLabel)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.secondaryText)

                Image(.distanceRun)
                    .resizable()
                    .scaledToFit()

                Text(.distanceScaleFieldMeasured)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.accentText)
            }
            .accessibilityHidden(true)
        }
    }
}

#Preview {
    Color.appBackground
        .sheet(isPresented: .constant(true)) {
            DistanceScaleHowToMeasureSheet()
        }
}
