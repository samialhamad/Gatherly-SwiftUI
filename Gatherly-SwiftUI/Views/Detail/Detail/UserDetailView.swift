//
//  UserDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct UserDetailView: View {
    @State private var cancellables = Set<AnyCancellable>()
    @State private var currentUser: User? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingActionSheet = false
    @State private var userFormStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    
    let user: User
    
    var body: some View {
        Group {
            if isViewingSelf {
                ProfileView()
            } else {
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
                    actionSheetButton
                }
                .confirmationDialog("Options", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                    Button("Edit") {
                        userFormStore = Store(
                            initialState: UserFormFeature.State(
                                currentUser: user,
                                firstName: user.firstName ?? "",
                                lastName: user.lastName ?? "",
                                avatarImageName: user.avatarImageName,
                                bannerImageName: user.bannerImageName,
                                avatarImage: user.avatarImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                                bannerImage: user.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                                isCreatingFriend: false
                            ),
                            reducer: { UserFormFeature() }
                        )
                    }
                    
                    Button("Remove Friend", role: .destructive) {
                        Task {
                            await removeFriend()
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(isPresented: Binding(
                    get: { userFormStore != nil },
                    set: { if !$0 { userFormStore = nil } }
                )) {
                    if let store = userFormStore {
                        UserFormView(store: store, onComplete: handleEditComplete)
                    }
                }
            }
        }
        .onAppear {
            GatherlyAPI.getUsers()
                .receive(on: RunLoop.main)
                .sink { users in
                    self.currentUser = users.first(where: { $0.id == 1 })
                }
                .store(in: &cancellables)
        }
    }
}

private extension UserDetailView {
    
    //MARK: - Computed Vars
    
    private var isViewingSelf: Bool {
        currentUser?.id == user.id
    }
    
    //MARK: - Functions
    
    func handleEditComplete(_ action: UserFormFeature.Action) {
        guard case let .delegate(.didSave(updatedUser)) = action else {
            userFormStore = nil
            return
        }
        
        GatherlyAPI.updateUser(updatedUser)
            .flatMap { _ in
                GatherlyAPI.getUsers()
            }
            .receive(on: RunLoop.main)
            .sink { users in
                self.currentUser = users.first(where: { $0.id == 1 })
            }
            .store(in: &cancellables)
        
        userFormStore = nil
    }
    
    private func removeFriend() async {
        guard let targetID = user.id else {
            return
        }
        guard let currentUser else {
            return
        }
        
        currentUser.friendIDs?.removeAll(where: { $0 == targetID })
        
        GatherlyAPI.updateUser(currentUser)
            .flatMap { _ in
                GatherlyAPI.deleteUser(user)
            }
            .receive(on: RunLoop.main)
            .sink { _ in
                dismiss()
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Subviews
    
    var actionSheetButton: some View {
        Button(action: {
            isShowingActionSheet = true
        }) {
            Image(systemName: "ellipsis")
        }
        .accessibilityIdentifier("userDetailOptionsButton")
    }
    
    var userInfoView: some View {
        VStack(alignment: .center, spacing: Constants.UserDetailView.vstackSpacing) {
            Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                .accessibilityIdentifier("userDetailFullName")
                .font(.title)
                .fontWeight(.bold)
            
            if let phone = user.phone {
                Text(phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        NavigationStack {
            UserDetailView(user: sampleUser)
        }
    }
}
