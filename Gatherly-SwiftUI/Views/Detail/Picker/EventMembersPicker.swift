//
//  EventMembersPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/18/25.
//

import SwiftUI

struct EventMembersPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMemberIDs: Set<Int>
    
    let allUsers: [User]
    let currentUser: User

    var body: some View {
        NavigationStack {
            List(allUsers, id: \.id) { user in
                Button(action: {
                    toggleMemberSelection(user.id)
                }) {
                    HStack {
                        Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                            .foregroundColor(.primary)
                        Spacer()
                        if selectedMemberIDs.contains(user.id ?? -1) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(Colors.primary))
                        }
                    }
                    .contentShape(Rectangle())
                }
                .listRowSeparator(.hidden)
            }
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: Constants.EventMembersPicker.topPadding)
            }
            .navigationTitle("Invite Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func toggleMemberSelection(_ id: Int?) {
        guard let id = id else { return }
        if selectedMemberIDs.contains(id) {
            selectedMemberIDs.remove(id)
        } else {
            selectedMemberIDs.insert(id)
        }
    }
}
