////  GuideProgressBar.swift
//

import SwiftUI

struct GuideProgressBar: View {
    let stepStates: [GuideStepState]
    var segmentHeight = 8.0

    var body: some View {
        HStack(spacing: 6) {
            ForEach(stepStates.indices, id: \.self) { index in
                Capsule()
                    .fill(color(for: stepStates[index]))
                    .frame(height: segmentHeight)
            }
        }
    }

    private func color(for state: GuideStepState) -> Color {
        switch state {
        case .done, .current: .accentFill
        case .skipped: .skippedStep
        case .upcoming: .controlTrack
        }
    }
}

#Preview {
    GuideProgressBar(stepStates: [.done, .done, .current, .upcoming, .skipped])
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
