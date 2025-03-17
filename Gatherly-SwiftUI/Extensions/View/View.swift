//
//  View.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import SwiftUI

extension View {
    func applyGatherlyToolbarStyle() -> some View {
        self.toolbarColor(Color(Brand.Colors.secondary))
    }
    
    private func toolbarColor(_ color: Color) -> some View {
        self.tint(color)
    }
    
    func centerText() -> some View {
        self.modifier(CenteredTextModifier())
    }
}
