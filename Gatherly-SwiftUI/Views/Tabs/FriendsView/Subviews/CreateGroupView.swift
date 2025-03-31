//
//  CreateGroupView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct CreateGroupView: View {
    let currentUser: User
    
    var body: some View {
        Text("Create Group for \(currentUser.firstName ?? "")")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
    }
}
