//
//  GroupRow.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import SwiftUI

struct GroupRow: View {
    let group: UserGroup

    var body: some View {
        HStack {
            AvatarView(
                group: group,
                size: Constants.GroupRow.avatarCircleSize,
                font: .headline,
                backgroundColor: Color(Colors.primary)
            )
            
            VStack(alignment: .leading) {
                Text(group.name)
                    .font(.body)
                Text("\(group.memberIDs.count) members")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, Constants.ProfileRow.hstackPadding)
    }
}
