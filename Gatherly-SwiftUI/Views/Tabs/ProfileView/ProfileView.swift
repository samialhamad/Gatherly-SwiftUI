//
//  ProfileView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/21/25.
//

import SwiftUI

struct ProfileView: View {
    let currentUser: User?

    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(spacing: Constants.ProfileView.vstackSpacing) {
                    AvatarHeaderView(user: currentUser)

                    VStack(spacing: Constants.ProfileView.profileVStackSpacing) {
                        profileRow(title: "Profile", icon: "person.fill")
                        profileRow(title: "Availability", icon: "calendar.badge.clock")
                        profileRow(title: "Settings", icon: "gearshape.fill")
                        profileRow(title: "Logout", icon: "arrow.backward.circle.fill", isDestructive: true)
                    }
                }
            }
            .navigationTitle("\(currentUser?.firstName ?? "") \(currentUser?.lastName ?? "")")
            .navigationBarTitleDisplayMode(.large)
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
}

#Preview {
    ProfileView(currentUser: SampleData.sampleUsers.first)
}
