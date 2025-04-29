//
//  ViewModifier.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/2/25.
//

import SwiftUI

struct CenteredTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}

struct DisclosureIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Image(systemName: "chevron.right")
                .foregroundColor(Color(Colors.primary))
        }
    }
}

struct RefreshOnAppearModifier: ViewModifier {
    @State private var refreshID = UUID()
    
    func body(content: Content) -> some View {
        content
            .id(refreshID)
            .onAppear {
                refreshID = UUID()
            }
    }
}

struct RefreshOnDismissModifier: ViewModifier {
    @State private var refreshID = UUID()

    func body(content: Content) -> some View {
        content
            .id(refreshID)
            .onDisappear {
                refreshID = UUID()
            }
    }
}
