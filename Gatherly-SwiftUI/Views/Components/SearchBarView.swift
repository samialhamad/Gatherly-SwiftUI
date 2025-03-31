//
//  SearchBarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(Colors.primary))
            TextField(placeholder, text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
        }
        .padding()
    }
}
