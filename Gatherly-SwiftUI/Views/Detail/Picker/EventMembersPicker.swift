//
//  EventMembersPicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/18/25.
//

import SwiftUI

struct EventMembersPicker: View {
    @EnvironmentObject var session: AppSession
    @Environment(\.dismiss) var dismiss
    @Binding var selectedMemberIDs: Set<Int>
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var friends: [User] {
        guard let currentUser else {
            return []
        }
        
        return currentUser
            .resolvedFriends(from: session.friendsDict)
            .filter { $0.id != currentUser.id }
    }
    
    var body: some View {
        NavigationStack {
            List(friends, id: \.id) { user in
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
