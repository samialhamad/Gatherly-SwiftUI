//
//  EventDetailsSection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventDetailsSection: View {
    let header: String
    @Binding var title: String
    @Binding var description: String
    @FocusState private var isDescriptionFocused: Bool
    
    var body: some View {
        Section(header: Text(header)) {
            TextField("Title", text: $title)
                .accessibilityIdentifier("eventTitleTextField")
            
            HStack(alignment: .top) {
                TextField("Description", text: $description, axis: .vertical)
                    .accessibilityIdentifier("eventDescriptionTextField")
                    .lineLimit(3, reservesSpace: true)
                    .tint(Color(Colors.primary))
                    .focused($isDescriptionFocused)
                
                if isDescriptionFocused {
                    ClearButton(text: $description)
                }
            }
        }
    }
}
