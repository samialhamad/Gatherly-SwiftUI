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
                size: Constants.GroupRow.avatarCircleSize
            )
            
            groupInfoView
            
            Spacer()
        }
        .padding(.vertical, Constants.ProfileRow.hstackPadding)
    }
}

private extension GroupRow {
    var groupInfoView: some View {
        VStack(alignment: .leading) {
            Text(group.name)
                .font(.body)
            Text("\(group.memberIDs.count) members")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    GroupRow(group: SampleData.sampleGroups.first!)
        .padding()
}
