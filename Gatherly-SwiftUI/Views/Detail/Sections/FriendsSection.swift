//
//  FriendsSection.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import Combine
import SwiftUI

public struct FriendsSection: View {
    @State var cancellables = Set<AnyCancellable>()
    @State var friends: [User] = []
    @State var isMembersPickerPresented = false
    @Binding var selectedMemberIDs: Set<Int>
    
    let header: String
        
    public var body: some View {
        Section(header: Text(header)) {
            Button(action: {
                isMembersPickerPresented.toggle()
            }) {
                HStack {
                    Text("Invite Friends")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(selectedMemberIDs.count) selected")
                        .foregroundColor(.secondary)
                }
                .addDisclosureIcon()
            }
            .accessibilityIdentifier("inviteFriendsButton")
            .sheet(isPresented: $isMembersPickerPresented) {
                FriendsPicker(selectedMemberIDs: $selectedMemberIDs)
            }
        }
        .onAppear {
            Publishers.CombineLatest(GatherlyAPI.getCurrentUser(), GatherlyAPI.getUsers())
                .receive(on: RunLoop.main)
                .sink { user, friendsList in
                    if let user {
                        let friendsDict = friendsList.keyedBy(\.id)
                        
                        self.friends = user
                            .friends(from: friendsDict)
                            .filter { $0.id != SampleData.currentUserID }
                    }
                }
                .store(in: &cancellables)
        }
    }
}
