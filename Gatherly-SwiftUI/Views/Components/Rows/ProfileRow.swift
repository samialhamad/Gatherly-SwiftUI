//
//  ProfileRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct ProfileRow: View {
    let user: User

    var initials: String {
        let firstInitial = user.firstName?.first.map(String.init) ?? ""
        let lastInitial = user.lastName?.first.map(String.init) ?? ""
        return firstInitial + lastInitial
    }
    
    var body: some View {
        HStack {
            //avatar placeholder - user initial
            Circle()
                .fill(Color(Colors.primary))
                .frame(width: Constants.ProfileRow.avatarCircleWidth, height: Constants.ProfileRow.avatarCircleHeight)
                .overlay(
                    Text(initials)
                        .font(.headline)
                        .foregroundColor(.white)
                )
            VStack(alignment: .leading) {
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    .font(.body)
            }
            Spacer()
        }
        .padding(.vertical, Constants.ProfileRow.hstackPadding)
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
