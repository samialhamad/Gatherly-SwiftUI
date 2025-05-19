//
//  UserDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI
import ComposableArchitecture

struct UserDetailView: View {
    @EnvironmentObject var session: AppSession
    @State private var isShowingActionSheet = false
    @State private var userFormStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    
    let user: User
    
    private var currentUser: User? {
        session.currentUser
    }
    
    var body: some View {
        if isViewingSelf {
            ProfileView()
                .environmentObject(session)
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
}

private extension UserDetailView {
    
    //MARK: - Computed Vars
    
    private var isFriend: Bool {
        guard let userID = user.id else {
            return false
        }
        
        return currentUser?.friendIDs?.contains(userID) == true
    }
    
    private var isViewingSelf: Bool {
        currentUser?.id == user.id
    }
    
    //MARK: - Functions
    
    private func handleEditComplete(_ action: UserFormFeature.Action) {
        var updatedUser: User?
        
        if case let .delegate(.didSave(user)) = action {
            updatedUser = user
        }
        
        guard let user = updatedUser else {
            userFormStore = nil
            return
        }
        
        if let index = session.users.firstIndex(where: { $0.id == user.id }) {
            session.users[index] = user
            session.saveAllData()
            session.updateLocalFriendsAndGroups()
        }
        
        userFormStore = nil
    }
    
    //MARK: - Subviews
    
    var actionSheetButton: some View {
        Button(action: {
            isShowingActionSheet = true
        }) {
            Image(systemName: "ellipsis")
        }
    }
    
    var userInfoView: some View {
        VStack(alignment: .center, spacing: Constants.UserDetailView.vstackSpacing) {
            Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                .font(.title)
                .fontWeight(.bold)
            
            if isFriend, let phone = user.phone {
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
                .environmentObject(AppSession())
        }
    }
}
