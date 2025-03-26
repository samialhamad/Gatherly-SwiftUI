//
//  DisclosureIconModifier.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/19/25.
//

import SwiftUI

struct DisclosureIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Image(systemName: "chevron.right")
                .foregroundColor(Color(Colors.primary))
        }
    }
}
