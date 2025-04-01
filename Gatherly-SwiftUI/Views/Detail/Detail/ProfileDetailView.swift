//
//  ProfileDetailView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct ProfileDetailView: View {
    let user: User
    
    var body: some View {
        ScrollView {
            VStack {
                AvatarHeaderView(user: user)
                
                VStack(alignment: .center, spacing: Constants.ProfileDetailView.vstackSpacing) {
                    Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let email = user.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    if let phone = user.phone {
                        Text(phone)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileDetailView(user: SampleData.sampleUsers.first!)
        }
    }
}
