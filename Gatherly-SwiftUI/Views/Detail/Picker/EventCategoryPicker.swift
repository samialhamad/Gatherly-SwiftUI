//
//  EventCategoryPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/17/25.
//

import SwiftUI

struct EventCategoryPicker: View {
    @Binding var selectedCategories: [EventCategory]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            CategoryList(selectedCategories: $selectedCategories)
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
    @Binding var selectedCategories: [EventCategory]
    
    var body: some View {
        List {
            Section {
            ForEach(EventCategory.allCases, id: \.self) { category in
                Button(action: {
                    toggleCategorySelection(category)
                }) {
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedCategories.contains(category) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(Colors.primary))
                        }
                    }
                    .contentShape(Rectangle())
                }
                .listRowSeparator(.hidden)
            }
            
            UnselectAllButton(selectedCategories: $selectedCategories)
                .frame(maxWidth: .infinity)
            }
        }
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: Constants.CategoryListView.topPadding)
        }
    }
    
    private func toggleCategorySelection(_ category: EventCategory) {
        if selectedCategories.contains(category) {
            selectedCategories.removeAll { $0 == category }
        } else {
            selectedCategories.append(category)
        }
    }
}

private struct UnselectAllButton: View {
    @Binding var selectedCategories: [EventCategory]
    
    var body: some View {
        Button(action: {
            selectedCategories.removeAll()
        }) {
            Text("Unselect All")
                .font(.headline)
                .foregroundColor(Color(Colors.primary))
        }
    }
}
