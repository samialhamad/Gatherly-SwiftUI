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
            //avatar placeholder - user initial
            Circle()
                .fill(Color(Brand.Colors.primary))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(user.firstName?.prefix(1) ?? "")
                        .font(.headline)
                        .foregroundColor(.white)
                )
            VStack(alignment: .leading) {
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    .font(.body)
            }
            Spacer()
        }
        .padding(.vertical, 4)
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
