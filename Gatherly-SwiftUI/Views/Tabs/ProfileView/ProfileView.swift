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
    @State private var userFormStore: Store<UserFormFeature.State, UserFormFeature.Action>? = nil
    @State private var refreshID = UUID()
    
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
    }
}

private extension ProfileView {
    
    // MARK: - Computed Vars
    
    var fullName: String {
        "\(currentUser.firstName ?? "") \(currentUser.lastName ?? "")"
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
            
            profileRow(title: "Availability", icon: "calendar.badge.clock")
            profileRow(title: "Settings", icon: "gearshape.fill")
            profileRow(title: "Logout", icon: "arrow.backward.circle.fill")
            profileRow(title: "Delete Account", icon: "minus.circle.fill", isDestructive: true)
        }
    }
}

#Preview {
    let sampleUser = SampleData.sampleUsers.first!
    
    ProfileView(currentUser: sampleUser)
}
