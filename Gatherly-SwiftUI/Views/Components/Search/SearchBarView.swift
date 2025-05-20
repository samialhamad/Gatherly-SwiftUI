//
//  SearchBarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(Colors.primary))
            TextField(placeholder, text: $searchText)
                .accessibilityIdentifier("friendsSearchField")
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .focused($isFocused)
        }
        .padding()
        .onTapGesture {
            isFocused = true
        }
    }
}
