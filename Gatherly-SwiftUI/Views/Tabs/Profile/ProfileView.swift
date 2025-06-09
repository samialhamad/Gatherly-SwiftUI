//
//  ProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var userFormStore: Store<UserFormReducer.State, UserFormReducer.Action>? = nil
    @EnvironmentObject var usersViewModel: UsersViewModel
    @State private var refreshID = UUID()
    
    private var isLoading: Bool {
        usersViewModel.isLoading || usersViewModel.currentUser == nil
    }
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ActivityIndicator(message: Constants.ProfileView.loadingString)
            } else if let currentUser = usersViewModel.currentUser {
                ScrollView {
                    VStack(spacing: Constants.ProfileView.vstackSpacing) {
                        AvatarHeaderView(
                            refreshID: refreshID,
                            mode: .user(user: currentUser)
                        )
                        profileRowsSection(currentUser)
                    }
                }
                .navigationTitle(fullName(for: currentUser))
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .sheet(isPresented: Binding(
            get: { userFormStore != nil },
            set: { newValue in
                if !newValue {
                    userFormStore = nil
                }
            }
        )) {
            if let store = userFormStore {
                UserFormView(
                    store: store,
                    delegate: self
                )
            }
        }
        .refreshOnAppear()
        .onAppear {
            usersViewModel.loadIfNeeded()
        }
    }
}

private extension ProfileView {
    
    // MARK: - Computed Vars
    
    func fullName(for user: User) -> String {
        "\(user.firstName ?? "") \(user.lastName ?? "")"
    }
    
    // MARK: - Functions
    
    func dismissUserFormView() {
        userFormStore = nil
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private func profileRow(
        title: String,
        icon: String,
        isDestructive: Bool = false,
        identifier: String? = nil,
        action: @escaping () -> Void = {}
    ) -> some View {
        Button(action: action) {
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
        .accessibilityIdentifier(identifier ?? "")
    }
    
    func profileRowsSection(_ currentUser: User) -> some View {
        VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
            profileRow(
                title: "Profile",
                icon: "person.fill",
                identifier: "editProfileButton"
            ) {
                let avatarImage: UIImage?
                if let avatarImageName = currentUser.avatarImageName {
                    avatarImage = ImageUtility.loadImageFromDocuments(named: avatarImageName)
                } else {
                    avatarImage = nil
                }
                
                let bannerImage: UIImage?
                if let bannerImageName = currentUser.bannerImageName {
                    bannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
                } else {
                    bannerImage = nil
                }
                
                userFormStore = Store(
                    initialState: UserFormReducer.State(
                        currentUser: currentUser,
                        firstName: currentUser.firstName ?? "",
                        lastName: currentUser.lastName ?? "",
                        avatarImageName: currentUser.avatarImageName,
                        bannerImageName: currentUser.bannerImageName,
                        avatarImage: avatarImage,
                        bannerImage: bannerImage,
                        mode: .updateCurrentUser
                    ),
                    reducer: { UserFormReducer() }
                )
            }
            
            profileRow(
                title: "Sync Contacts",
                icon: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill",
                identifier: "syncContactsButton"
            ) {
                usersViewModel.isLoading = true
                ContactSyncHelper.forceSync(currentUserID: SampleData.currentUserID) {
                    usersViewModel.forceReload()
                }
            }
            
            profileRow(
                title: "Logout",
                icon: "arrow.backward.circle.fill",
                identifier: "logoutButton"
            )
            
            profileRow(
                title: "Delete Account",
                icon: "minus.circle.fill",
                isDestructive: true,
                identifier: "deleteAccountButton"
            )
        }
    }
}

//MARK: - UserFormViewDelegate

extension ProfileView: UserFormViewDelegate {
    func userFormViewDidCancel() {
        dismissUserFormView()
    }
    
    func userFormViewDidUpdateUser(updatedUser: User) {
        usersViewModel.update(updatedUser)
        refreshID = UUID()
        dismissUserFormView()
    }
}

#Preview {
    ProfileView()
}
