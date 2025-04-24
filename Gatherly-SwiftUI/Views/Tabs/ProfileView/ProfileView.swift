//
//  ProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
    @ObservedObject var currentUser: User
    @State private var editProfileStore: Store<EditProfileFeature.State, EditProfileFeature.Action>? = nil
    @State private var isShowingEditSheet = false
    @Binding var users: [User]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.ProfileView.vstackSpacing) {
                    AvatarHeaderView(user: currentUser)
                    
                    VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
                        Button {
                                editProfileStore = Store(
                                    initialState: EditProfileFeature.State(
                                        allUsers: users,
                                        currentUser: currentUser,
                                        firstName: currentUser.firstName ?? "",
                                        lastName: currentUser.lastName ?? "",
                                        avatarImageName: currentUser.avatarImageName,
                                        bannerImageName: currentUser.bannerImageName
                                    ),
                                    reducer: {
                                        EditProfileFeature()
                                    }
                                )
                                isShowingEditSheet = true
                        } label: {
                            profileRowContent(title: "Profile", icon: "person.fill")
                        }
                        
                        profileRow(title: "Availability", icon: "calendar.badge.clock")
                        profileRow(title: "Settings", icon: "gearshape.fill")
                        profileRow(title: "Logout", icon: "arrow.backward.circle.fill", isDestructive: true)
                    }
                }
            }
            .navigationTitle("\(currentUser.firstName ?? "") \(currentUser.lastName ?? "")")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $isShowingEditSheet) {
            if let store = editProfileStore {
                EditProfileView(
                    store: store,
                    onComplete: { action in
                        switch action {
                        case let .delegate(.didSave(updatedUser)):
                            if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
                                users[index] = updatedUser
                            }
                            
                        case .cancel:
                            break
                            
                        default:
                            break
                        }
                        
                        isShowingEditSheet = false
                        editProfileStore = nil
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    private func profileRow(title: String, icon: String, isDestructive: Bool = false) -> some View {
        Button {
            // Action placeholder – to be implemented with TCA
        } label: {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : Color(Colors.primary))
                    .frame(width: Constants.ProfileView.profileRowIconFrameWidth)
                Text(title)
                    .foregroundColor(isDestructive ? .red : Color(Colors.primary))
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(Colors.primary))
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func profileRowContent(title: String, icon: String, isDestructive: Bool = false) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : Color(Colors.primary))
                .frame(width: Constants.ProfileView.profileRowIconFrameWidth)
            Text(title)
                .foregroundColor(isDestructive ? .red : Color(Colors.primary))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color(Colors.primary))
        }
        .padding()
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        ProfileView(
            currentUser: sampleUser,
            users: .constant(SampleData.sampleUsers)
        )
    }
}
