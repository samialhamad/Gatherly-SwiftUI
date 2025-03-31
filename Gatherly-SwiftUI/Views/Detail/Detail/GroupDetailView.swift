//
//  GroupDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import SwiftUI

struct GroupDetailView: View {
    let group: UserGroup
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(group: group)
                
                VStack(spacing: 8) {
                    Text("Leader ID: \(group.leaderID)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(group.memberIDs.count) members")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
        }
        .navigationTitle(group.name)
    }
}
