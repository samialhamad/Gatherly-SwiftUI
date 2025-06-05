//
//  View.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/13/25.
//

import SwiftUI

extension View {
    
    // MARK: - Activity Indicator
    
    func addActivityIndicator(isPresented: Bool, message: String? = nil) -> some View {
        ZStack {
            self
            if isPresented {
                ActivityIndicator(message: message)
            }
        }
    }
    
    // MARK: - Tint Accent
    
    func applyGatherlyAccentColor() -> some View {
        self.tint(Color(Colors.secondary))
    }
    
    // MARK: - Text
    
    func centerText() -> some View {
        self.modifier(CenteredTextModifier())
    }
    
    // MARK: - Disclosure Icon
    
    func addDisclosureIcon(color: Color = .gray) -> some View {
        self.modifier(DisclosureIconModifier())
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
        self.modifier(RefreshOnAppearModifier())
    }
}
