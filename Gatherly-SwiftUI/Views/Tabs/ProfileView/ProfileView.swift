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
    @State private var refreshID = UUID()
    @Binding var users: [User]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.ProfileView.vstackSpacing) {
                    AvatarHeaderView(
                        refreshID: refreshID,
                        user: currentUser
                    )
                    profileRowsSection
                }
            }
            .navigationTitle(fullName)
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $isShowingEditSheet) {
            editProfileSheet
        }
        .refreshOnAppear()
    }
}

private extension ProfileView {
    
    // MARK: - Computed Vars
    
    var fullName: String {
        "\(currentUser.firstName ?? "") \(currentUser.lastName ?? "")"
    }
    
    // MARK: - Subviews
    
    var editProfileSheet: some View {
        if let store = editProfileStore {
            return AnyView(
                EditProfileView(
                    store: store,
                    onComplete: { action in
                        switch action {
                        case .cancel:
                            break
                        case .delegate(let delegateAction):
                            if case let .didSave(updatedUser) = delegateAction,
                               let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
                                users[index] = updatedUser
                                refreshID = UUID()
                            }
                        default:
                            break
                        }
                        
                        isShowingEditSheet = false
                        editProfileStore = nil
                    }
                )
            )
        } else {
            return AnyView(EmptyView())
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
    
    var profileRowsSection: some View {
        VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
            Button {
                editProfileStore = Store(
                    initialState: EditProfileFeature.State(
                        allUsers: users,
                        currentUser: currentUser,
                        firstName: currentUser.firstName ?? "",
                        lastName: currentUser.lastName ?? "",
                        avatarImageName: currentUser.avatarImageName,
                        bannerImageName: currentUser.bannerImageName,
                        avatarImage: currentUser.avatarImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                        bannerImage: currentUser.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
                    ),
                    reducer: { EditProfileFeature() }
                )
                isShowingEditSheet = true
            } label: {
                profileRowContent(title: "Profile", icon: "person.fill")
            }
            
            profileRow(title: "Availability", icon: "calendar.badge.clock")
            profileRow(title: "Settings", icon: "gearshape.fill")
            profileRow(title: "Logout", icon: "arrow.backward.circle.fill")
        }
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
