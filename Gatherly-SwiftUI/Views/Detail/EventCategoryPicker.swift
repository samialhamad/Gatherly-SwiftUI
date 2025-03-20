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
            VStack {
                CategoryList(selectedCategories: $selectedCategories)
                UnselectAllButton(selectedCategories: $selectedCategories)
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

// MARK: - Subviews

private struct CategoryList: View {
    @Binding var selectedCategories: [Brand.EventCategory]
    
    var body: some View {
        List(Brand.EventCategory.allCases, id: \.self) { category in
            Button(action: {
                toggleCategorySelection(category)
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
    }
    
    private func toggleCategorySelection(_ category: Brand.EventCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
}

private struct UnselectAllButton: View {
    @Binding var selectedCategories: [Brand.EventCategory]
    
    var body: some View {
        Button(action: {
            selectedCategories.removeAll()
        }) {
            Text("Unselect All")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.bottom, 20)
    }
}
