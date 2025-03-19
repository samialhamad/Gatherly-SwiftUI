//
//  ClearButton.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/18/25.
//

import SwiftUI

struct ClearButton: View {
    @Binding var text: String
    var onClear: (() -> Void)? = nil

    var body: some View {
        if !text.isEmpty {
            Button(action: {
                text = ""
                onClear?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}
