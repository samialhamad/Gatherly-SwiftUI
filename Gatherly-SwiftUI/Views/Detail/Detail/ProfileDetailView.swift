//
//  ProfileDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct ProfileDetailView: View {
    let user: User
    let currentUser: User = SampleData.sampleUsers[0] // replace with actual logic
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(user: user)
                
                VStack(alignment: .center, spacing: Constants.ProfileDetailView.vstackSpacing) {
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
                Spacer()
            }
        }
        .navigationTitle("\(user.firstName ?? "") \(user.lastName ?? "")")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Report") {
                    }
                    
                    if isFriend {
                        Button("Remove Friend", role: .destructive) {
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

private extension ProfileDetailView {
    var isFriend: Bool {
        guard let userID = user.id else { return false }
        return currentUser.friendIDs?.contains(userID) == true
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileDetailView(user: SampleData.sampleUsers.first!)
        }
    }
}
