//
//  ProfileDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var currentUser: User
    @State private var isShowingActionSheet = false
    @ObservedObject var user: User
    
    var body: some View {
        if isViewingSelf {
            ProfileView(
                currentUser: currentUser
            )
        } else {
            ScrollView {
                VStack {
                    AvatarHeaderView(
                        user: user
                    )
                    
                    userInfoView
                    
                    Spacer()
                }
            }
            .navigationTitle("\(user.firstName ?? "") \(user.lastName ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                actionSheetButton
            }
            .confirmationDialog("Options", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                Button("Report", role: .destructive) {
                    // handle report
                }
                if isFriend {
                    Button("Remove Friend", role: .destructive) {
                        // handle remove friend
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

private extension ProfileDetailView {
    
    //MARK: - Computed Vars
    
    var isFriend: Bool {
        guard let userID = user.id else { return false }
        return currentUser.friendIDs?.contains(userID) == true
    }
    
    private var isViewingSelf: Bool {
        currentUser.id == user.id
    }
    
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
                .cornerRadius(Constants.ProfileDetailView.friendButtonRadius)
        }
        .padding(.top, Constants.ProfileDetailView.friendButtonTopPadding)
        .padding(.horizontal, Constants.ProfileDetailView.friendButtonHorizontalPadding)
    }
    
    var actionSheetButton: some View {
        Button(action: {
            isShowingActionSheet = true
        }) {
            Image(systemName: "ellipsis")
        }
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        NavigationStack {
            ProfileDetailView(
                currentUser: sampleUser,
                user: sampleUser
            )
        }
    }
}
