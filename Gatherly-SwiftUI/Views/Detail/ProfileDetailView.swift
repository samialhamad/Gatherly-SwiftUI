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
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color(Colors.primary))
                        .frame(height: 200)
                    
                    AvatarView(
                        user: user,
                        size: 100,
                        font: .largeTitle,
                        backgroundColor: Color(Colors.primary),
                        borderColor: .white,
                        borderWidth: 4
                    )
                    .offset(y: 50)
                }
                .padding(.bottom, 50)
                
                VStack(alignment: .center, spacing: 8) {
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
