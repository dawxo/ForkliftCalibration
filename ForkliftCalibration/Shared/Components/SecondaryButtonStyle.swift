////  SecondaryButtonStyle.swift
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    private static let shape = RoundedRectangle(cornerRadius: 18)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.accentText)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(minWidth: 110, minHeight: 64)
            .background(Color.cellBackground, in: Self.shape)
            .overlay {
                Self.shape.strokeBorder(Color.separatorLine, lineWidth: 1.5)
            }
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: Self { SecondaryButtonStyle() }
}

#Preview {
    Button(.guideBack) {}
        .buttonStyle(.secondary)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
