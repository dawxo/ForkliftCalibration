////  GuideHeader.swift
//

import SwiftUI

struct GuideHeader: View {
    let caption: LocalizedStringResource
    let title: LocalizedStringResource
    let message: LocalizedStringResource?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(caption)
                .font(.footnote)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .tracking(0.8)
                .foregroundStyle(Color.secondaryText)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color.primaryText)

            if let message {
                Text(message)
                    .font(.title3)
                    .foregroundStyle(Color.primaryText)
            }
        }
        .padding(.horizontal, 4)
    }
}
