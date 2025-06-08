//
//  EventCategorySection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct EventCategorySection: View {
    let header: String
    @Binding var selectedCategories: [EventCategory]
    @State private var isCategoryPickerPresented = false
    
    var body: some View {
        Section(header: Text(header)) {
            Button(action: {
                isCategoryPickerPresented.toggle()
            }) {
                HStack {
                    Text(selectedCategories.isEmpty ? "Select Categories" : selectedCategories.map { $0.rawValue }.joined(separator: ", "))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .addDisclosureIcon()
                .padding(.vertical, Constants.EventCategorySection.verticalPadding)
            }
            .accessibilityIdentifier("categoryPickerButton")
            .sheet(isPresented: $isCategoryPickerPresented) {
                EventCategoryPicker(selectedCategories: $selectedCategories)
            }
        }
    }
}
