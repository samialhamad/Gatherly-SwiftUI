//
//  ProfileDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct ProfileDetailView: View {
    let user: User
    let currentUser: User = SampleData.sampleUsers[0] // replace with actual logic
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(user: user)
                userInfoView
                Spacer()
            }
        }
        .navigationTitle("\(user.firstName ?? "") \(user.lastName ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                menuButton
            }
        }
    }
}

private extension ProfileDetailView {
    
    //MARK: - Subviews
    
    var userInfoView: some View {
        VStack(alignment: .center, spacing: Constants.ProfileDetailView.vstackSpacing) {
            Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                .font(.title)
                .fontWeight(.bold)
            
            if isFriend, let phone = user.phone {
                Text(phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if !isFriend {
                addFriendButton
            }
        }
        .padding()
    }
    
    var addFriendButton: some View {
        Button(action: {
            // handle friend request
        }) {
            Text("Add Friend")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(Colors.primary))
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.top, 8)
        .padding(.horizontal, 32)
    }
    
    var menuButton: some View {
        Menu {
            Button("Report") {
                // handle report
            }
            if isFriend {
                Button("Remove Friend", role: .destructive) {
                    // handle remove
                }
            }
        } label: {
            Image(systemName: "ellipsis")
        }
    }
    
    //MARK: - Computed Vars
    
    var isFriend: Bool {
        guard let userID = user.id else { return false }
        return currentUser.friendIDs?.contains(userID) == true
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileDetailView(user: SampleData.sampleUsers.first!)
        }
    }
}
