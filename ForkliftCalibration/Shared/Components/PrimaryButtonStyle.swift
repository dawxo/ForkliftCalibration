////  PrimaryButtonStyle.swift
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title3)
            .fontWeight(.bold)
            .foregroundStyle(Color.onAccent)
            .multilineTextAlignment(.center)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, minHeight: 64)
            .background(Color.accentFill, in: .rect(cornerRadius: 18))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: Self { PrimaryButtonStyle() }
}

#Preview {
    Button(.leftRightCheckNext) {}
        .buttonStyle(.primary)
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity)
        .background(Color.appBackground)
}
