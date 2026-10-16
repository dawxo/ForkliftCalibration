////  GuideBottomBar.swift
//

import SwiftUI

struct GuideBottomBar<Buttons: View>: View {
    @ViewBuilder let buttons: Buttons

    var body: some View {
        HStack(spacing: 10) {
            buttons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.appBackground)
    }
}
