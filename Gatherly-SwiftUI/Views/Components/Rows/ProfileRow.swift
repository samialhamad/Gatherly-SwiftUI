//
//  ProfileRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct ProfileRow: View {
    let user: User
        
    var body: some View {
        HStack {
            AvatarView(
                backgroundColor: Color(Colors.primary),
                font: .headline,
                size: Constants.ProfileRow.avatarCircleSize,
                user: user
            )
            
            nameView
            
            Spacer()
        }
        .padding(.vertical, Constants.ProfileRow.hstackPadding)
    }
}

private extension ProfileRow {
    var nameView: some View {
        VStack(alignment: .leading) {
            Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                .font(.body)
        }
    }
}

#Preview {
    ProfileRow(user: User(
        createdTimestamp: nil,
        deviceToken: nil,
        email: "example@example.com",
        eventIDs: nil,
        firstName: "John",
        friendIDs: nil,
        id: 1,
        isEmailEnabled: nil,
        lastName: "Doe",
        phone: nil
    ))
}
