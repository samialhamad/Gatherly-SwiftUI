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
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingActionSheet = false
    @State private var userFormStore: Store<UserFormReducer.State, UserFormReducer.Action>? = nil
    @EnvironmentObject var usersViewModel: UsersViewModel
    
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
                            initialState: UserFormReducer.State(
                                currentUser: user,
                                firstName: user.firstName ?? "",
                                lastName: user.lastName ?? "",
                                avatarImageName: user.avatarImageName,
                                bannerImageName: user.bannerImageName,
                                avatarImage: user.avatarImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                                bannerImage: user.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) },
                                mode: .updateFriend
                            ),
                            reducer: { UserFormReducer() }
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
                        UserFormView(
                            store: store,
                            delegate: self
                        )
                    }
                }
            }
        }
    }
}

private extension UserDetailView {
    
    // MARK: - Computed Vars
    
    private var isViewingSelf: Bool {
        usersViewModel.currentUser?.id == user.id
    }
    
    // MARK: - Functions
    
    private func removeFriend() async {
        guard let targetID = user.id else {
            return
        }
        
        guard var currentUser = usersViewModel.currentUser else {
            return
        }
        
        currentUser.friendIDs?.removeAll(where: { $0 == targetID })
        usersViewModel.update(currentUser)
        usersViewModel.delete(user)
        
        dismiss()
    }
    
    // MARK: - Subviews
    
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

//MARK: - UserFormViewDelegate

extension UserDetailView: UserFormViewDelegate {
    func userFormViewDidCancel() {
        userFormStore = nil
    }
    
    func userFormViewDidUpdateUser(updatedUser: User) {
        usersViewModel.update(updatedUser)
        userFormStore = nil
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        NavigationStack {
            UserDetailView(user: sampleUser)
        }
    }
}
