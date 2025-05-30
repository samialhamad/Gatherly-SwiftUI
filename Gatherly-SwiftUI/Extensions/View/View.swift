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
    
    // MARK: - Toolbar
    
    func applyGatherlyToolbarStyle() -> some View {
        self.toolbarColor(Color(Colors.secondary))
    }
    
    private func toolbarColor(_ color: Color) -> some View {
        self.tint(color)
    }
    
    // MARK: - Text
    
    func centerText() -> some View {
        self.modifier(CenteredTextModifier())
    }
    
    // MARK: - Deletion Failed
    
    func deletionFailedAlert(for binding: Binding<Bool>, message: String) -> some View {
        self.alert("Failed to Delete", isPresented: binding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(message)
        }
    }
    
    // MARK: - Disclosure Icon
    
    func addDisclosureIcon(color: Color = .gray) -> some View {
        self.modifier(DisclosureIconModifier())
    }
    
    // MARK: - Keyboard
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    // MARK: - Refresh
    
    func refreshOnAppear() -> some View {
        self.modifier(RefreshOnAppearModifier())
    }
    
    func refreshOnDismiss() -> some View {
        self.modifier(RefreshOnDismissModifier())
    }
}
