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
        VStack(spacing: 20) {
            Text(group.name)
                .font(.largeTitle)
                .bold()
            Text("Leader ID: \(group.leaderID)")
            Text("Members: \(group.memberIDs.count)")
        }
        .navigationTitle("Group Info")
        .padding()
    }
}
