//
//  UserRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct UserRow: View {
    let user: User
        
    var body: some View {
        HStack {
            AvatarView(
                size: Constants.UserRow.avatarCircleSize,
                mode: .user(user: user)
            )
            
            nameView
            
            Spacer()
        }
        .padding(.vertical, Constants.UserRow.hstackPadding)
    }
}

private extension UserRow {
    var nameView: some View {
        VStack(alignment: .leading) {
            Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                .font(.body)
        }
    }
}

#Preview {
    UserRow(user: User(
        createdTimestamp: nil,
        eventIDs: nil,
        firstName: "John",
        friendIDs: nil,
        id: 1,
        lastName: "Doe",
        phone: nil
    ))
}
