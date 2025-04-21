//
//  ProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
    let currentUser: User?
    
    @State var store: Store<EditProfileFeature.State, EditProfileFeature.Action>? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.ProfileView.vstackSpacing) {
                    AvatarHeaderView(user: currentUser)

                    VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
                        Button {
                            if let user = currentUser {
                                store = Store<EditProfileFeature.State, EditProfileFeature.Action>(
                                    initialState: EditProfileFeature.State(
                                        firstName: user.firstName ?? "",
                                        lastName: user.lastName ?? "",
                                        avatarImage: nil,
                                        bannerImage: nil
                                    ),
                                    reducer: {
                                        EditProfileFeature()
                                    }
                                )
                            }
                        } label: {
                            profileRowContent(title: "Profile", icon: "person.fill")
                        }

                        profileRow(title: "Availability", icon: "calendar.badge.clock")
                        profileRow(title: "Settings", icon: "gearshape.fill")
                        profileRow(title: "Logout", icon: "arrow.backward.circle.fill", isDestructive: true)
                    }
                }
            }
            .navigationTitle("\(currentUser?.firstName ?? "") \(currentUser?.lastName ?? "")")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(
            item: $store,
            content: { EditProfileView(store: $0) }
        )
    }
    
    // MARK: - Functions

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
    ProfileView(currentUser: SampleData.sampleUsers.first)
}
