//
//  EventCategoryPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/17/25.
//

import SwiftUI

struct EventCategoryPicker: View {
    @Binding var selectedCategories: [Brand.EventCategory]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List(Brand.EventCategory.allCases, id: \.self) { category in
                Button(action: {
                    if selectedCategories.contains(category) {
                        selectedCategories.removeAll { $0 == category }
                    } else {
                        selectedCategories.append(category)
                    }
                }) {
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedCategories.contains(category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(Brand.Colors.primary))
                        }
                    }
                    .contentShape(Rectangle())
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("Select Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
