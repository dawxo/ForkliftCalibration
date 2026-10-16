////  GuideOverviewScreen.swift
//

import SwiftUI

struct GuideOverviewStep {
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
}

struct GuideOverviewScreen<GuideType: Guide>: View {
    let title: LocalizedStringResource
    let message: LocalizedStringResource
    let steps: [GuideOverviewStep]
    let progress: GuideType?
    let startAction: () -> Void
    let resumeAction: () -> Void

    @ScaledMetric(relativeTo: .title3) private var badgeSize = 34.0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                VStack(alignment: .leading, spacing: 8) {
                    Text(.guideOverviewSteps)
                        .font(.headline)
                        .foregroundStyle(Color.secondaryText)
                        .padding(.horizontal, 20)

                    stepList
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 22)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomBar
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var header: some View {
        if progress != nil {
            GuideHeader(
                caption: .guideOverviewInProgress,
                title: title,
                message: .guideOverviewInProgressMessage
            )
        } else {
            GuideHeader(
                caption: .guideOverviewStepCount(steps.count),
                title: title,
                message: message
            )
        }
    }

    private var stepList: some View {
        VStack(spacing: 0) {
            ForEach(steps.indices, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(Color.separatorLine)
                        .frame(height: 1)
                }
                stepRow(number: index + 1, step: steps[index], state: progress?.stepStates[index])
            }
        }
        .background(Color.cellBackground)
        .clipShape(.rect(cornerRadius: 20))
    }

    private func stepRow(
        number: Int,
        step: GuideOverviewStep,
        state: GuideStepState?
    ) -> some View {
        HStack(spacing: 14) {
            badge(number: number, state: state)

            VStack(alignment: .leading, spacing: 2) {
                Text(step.title)
                    .font(.title3)
                    .fontWeight(state == .current ? .bold : .semibold)
                    .foregroundStyle(Color.primaryText)

                Text(detail(for: step, state: state))
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 20)
        .frame(minHeight: 66)
        .overlay(alignment: .leading) {
            if state == .current {
                Rectangle()
                    .fill(Color.accentFill)
                    .frame(width: 4)
            }
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func badge(number: Int, state: GuideStepState?) -> some View {
        switch state {
        case .done:
            Image(systemName: "checkmark")
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.onAccent)
                .frame(width: badgeSize, height: badgeSize)
                .background(Color.passText, in: .circle)
        case .upcoming, .skipped:
            Text(number, format: .number)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.secondaryText)
                .frame(width: badgeSize, height: badgeSize)
                .overlay {
                    Circle()
                        .strokeBorder(Color.separatorLine, lineWidth: 2)
                }
        case .current, nil:
            Text(number, format: .number)
                .font(.body)
                .fontWeight(.bold)
                .foregroundStyle(Color.onAccent)
                .frame(width: badgeSize, height: badgeSize)
                .background(Color.accentFill, in: .circle)
        }
    }

    private func detail(for step: GuideOverviewStep, state: GuideStepState?)
        -> LocalizedStringResource
    {
        switch state {
        case .done: .guideOverviewDone
        case .current: .guideOverviewNextUp
        case .skipped: .guideOverviewSkipped
        case .upcoming, nil: step.detail
        }
    }

    private var bottomBar: some View {
        GuideBottomBar {
            if let progress {
                Button(.guideStartOver, action: startAction)
                    .buttonStyle(.secondary)

                Button(.guideResume(progress.stepNumber), action: resumeAction)
                    .buttonStyle(.primary)
            } else {
                Button(.guideStart, action: startAction)
                    .buttonStyle(.primary)
            }
        }
    }
}
