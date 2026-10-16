////  HomeRow.swift
//

import SwiftUI

struct HomeRow: View {
    enum Tile {
        case guide
        case calculator
    }

    let tile: Tile
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    var stepStates: [GuideStepState]? = nil

    private let tileSize = 44.0
    private let progressBarWidth = 150.0

    var body: some View {
        HStack(spacing: 14) {
            tileView

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryText)

                if let stepStates {
                    GuideProgressBar(stepStates: stepStates, segmentHeight: 6)
                        .frame(width: progressBarWidth)
                        .padding(.top, 4)
                }
            }
        }
    }

    private var tileView: some View {
        Image(systemName: tile.symbolName)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(tile.symbolColor)
            .frame(width: tileSize, height: tileSize)
            .background(tile.backgroundColor, in: .rect(cornerRadius: 12))
    }
}

extension HomeRow.Tile {
    var symbolName: String {
        switch self {
        case .guide: "checklist"
        case .calculator: "plus.forwardslash.minus"
        }
    }

    var symbolColor: Color {
        switch self {
        case .guide: .onAccent
        case .calculator: .secondaryText
        }
    }

    var backgroundColor: Color {
        switch self {
        case .guide: .accentFill
        case .calculator: .controlTrack
        }
    }
}
