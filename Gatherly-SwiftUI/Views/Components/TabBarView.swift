//
//  TabBarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/5/25.
//

import SwiftUI
import AnimatedTabBar

struct TabBarView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        AnimatedTabBar(
            selectedIndex: $selectedIndex,
            views: [
                AnyView(fixedWiggleButton(systemName: "calendar", index: 0)),
                AnyView(fixedWiggleButton(systemName: "plus.app.fill", index: 1)),
                AnyView(fixedWiggleButton(systemName: "person.2.badge.plus.fill", index: 2, scale: 1.7)),
                AnyView(fixedWiggleButton(systemName: "person.crop.circle.fill", index: 3))
            ]
        )
        .barColor(Color(Colors.primary))
        .selectedColor(.white)
        .unselectedColor(.white.opacity(0.5))
        .ballColor(Color(Colors.primary))
        .verticalPadding(28)
        .cornerRadius(24)
        .ballTrajectory(.parabolic)
    }
    
    private func fixedWiggleButton(systemName: String, index: Int, scale: CGFloat = 1.2) -> some View {
        WiggleButton(
            image: Image(systemName: systemName),
            maskImage: Image(systemName: systemName),
            isSelected: selectedIndex == index
        )
        .scaleEffect(scale)
    }
}
