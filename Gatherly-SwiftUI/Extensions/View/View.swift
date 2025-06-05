//
//  View.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import SwiftUI

extension View {
    
    // MARK: - Tint Accent
    
    func applyGatherlyAccentColor() -> some View {
        tint(Color(Colors.secondary))
    }
    
    // MARK: - Text
    
    func centerText() -> some View {
        modifier(CenteredTextModifier())
    }
    
    // MARK: - Disclosure Icon
    
    func addDisclosureIcon(color: Color = .gray) -> some View {
        modifier(DisclosureIconModifier())
    }
    
    // MARK: - Keyboard
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    // MARK: - Refresh
    
    func refreshOnAppear() -> some View {
        modifier(RefreshOnAppearModifier())
    }
}
