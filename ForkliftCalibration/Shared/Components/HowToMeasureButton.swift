////  HowToMeasureButton.swift
//

import SwiftUI

struct HowToMeasureButton<Sheet: View>: View {
    let thumbnail: ImageResource
    let subtitle: LocalizedStringResource
    @ViewBuilder let sheet: Sheet

    @State private var isShowingSheet = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        Button {
            isShowingSheet = true
        } label: {
            HStack(spacing: 14) {
                if !dynamicTypeSize.isAccessibilitySize {
                    Image(thumbnail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 104)
                        .accessibilityHidden(true)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(.howToMeasureTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primaryText)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.forward")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.secondaryText)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 8)
            .padding(.leading, 14)
            .padding(.trailing, 18)
            .frame(minHeight: 72)
            .background(Color.cellBackground, in: .rect(cornerRadius: 20))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingSheet) {
            sheet
        }
    }
}
