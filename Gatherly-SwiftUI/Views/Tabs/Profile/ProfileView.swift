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
    @State private var currentUser: User? = nil
    @State private var isLoading = true
    @State private var userFormStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    @State private var refreshID = UUID()
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ActivityIndicator(message: Constants.ProfileView.loadingString)
            } else if let currentUser {
                ScrollView {
                    VStack(spacing: Constants.ProfileView.vstackSpacing) {
                        AvatarHeaderView(
                            refreshID: refreshID,
                            user: currentUser
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
                    onComplete: handleEditComplete
                )
            }
        }
        .refreshOnAppear()
        .onAppear {
            isLoading = true

            GatherlyAPI.getCurrentUser()
                .receive(on: RunLoop.main)
                .sink { currentUser in
                    self.currentUser = currentUser
                    self.isLoading = false
                }
                .store(in: &cancellables)
        }
    }
}

private extension ProfileView {
    
    // MARK: - Computed Vars
    
    func fullName(for user: User) -> String {
        "\(user.firstName ?? "") \(user.lastName ?? "")"
    }
    
    // MARK: Functions
    
    func handleEditComplete(_ action: UserFormFeature.Action) {
        switch action {
        case .cancel:
            break
        case .delegate(let delegateAction):
            if case .didSave = delegateAction {
                refreshID = UUID()
            }
        default:
            break
        }
        
        userFormStore = nil
    }
    
    // MARK: - Subviews
    
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
    private func profileRow(
        title: String,
        icon: String,
        isDestructive: Bool = false,
        identifier: String? = nil
    ) -> some View {
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
        .accessibilityIdentifier(identifier ?? "")
    }
    
    func profileRowsSection(_ currentUser: User) -> some View {
        VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
            Button {
                userFormStore = Store(
                    initialState: UserFormFeature.State(
                        currentUser: currentUser,
                        firstName: currentUser.firstName ?? "",
                        lastName: currentUser.lastName ?? "",
                        avatarImageName: currentUser.avatarImageName,
                        bannerImageName: currentUser.bannerImageName,
                        avatarImage: currentUser.avatarImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                        bannerImage: currentUser.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
                    ),
                    reducer: { UserFormFeature() }
                )
            } label: {
                profileRowContent(title: "Profile", icon: "person.fill")
            }
            .accessibilityIdentifier("editProfileButton")
            
            Button {
                ContactSyncHelper.runIfNeeded(currentUserID: 1)
            } label: {
                profileRowContent(
                    title: "Sync Contacts", icon: "arrow.trianglehead.2.clockwise.rotate.90.circle.fill")
            }
            .accessibilityIdentifier("syncContactsButton")
            
            profileRow(title: "Logout",
                       icon: "arrow.backward.circle.fill",
                       identifier: "logoutButton")
            
            profileRow(title: "Delete Account",
                       icon: "minus.circle.fill",
                       isDestructive: true,
                       identifier: "deleteAccountButton")
        }
    }
}

#Preview {
    ProfileView()
}
