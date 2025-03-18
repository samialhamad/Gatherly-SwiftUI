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
                Toggle(category.rawValue, isOn: Binding(
                    get: { selectedCategories.contains(category) },
                    set: { isSelected in
                        if isSelected {
                            selectedCategories.append(category)
                        } else {
                            selectedCategories.removeAll { $0 == category }
                        }
                    }
                ))
                .tint(Color(Brand.Colors.primary))
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
