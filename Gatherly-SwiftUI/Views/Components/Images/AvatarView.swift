//
//  AvatarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct AvatarView: View {
    
    enum Mode {
        case user(User)
        case group(UserGroup)
    }
    
    let backgroundColor: Color
    let borderColor: Color?
    let borderWidth: CGFloat?
    let font: Font
    let size: CGFloat
    private let mode: Mode?
    
    init(
        backgroundColor: Color = Color(Colors.primary),
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        font: Font = .headline,
        group: UserGroup? = nil,
        size: CGFloat,
        user: User? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.font = font
        self.size = size
        
        if let user {
            self.mode = .user(user)
        } else if let group {
            self.mode = .group(group)
        } else {
            self.mode = nil
        }
    }
    
    var body: some View {
        if let profileImage {
            profileImageView(profileImage)
        } else {
            initialsView
        }
    }
}

private extension AvatarView {
    
    // MARK: - Computed vars
    
    private var initials: String {
        guard let mode else {
            return ""
        }
        
        switch mode {
        case .user(let user):
            let firstInitial = user.firstName?.first.map(String.init) ?? ""
            let lastInitial  = user.lastName?.first.map(String.init)  ?? ""
            return firstInitial + lastInitial
            
        case .group(let group):
            guard let firstChar = group.name?.first else {
                return ""
            }
            
            return String(firstChar).uppercased()
        }
    }
    
    private var profileImage: UIImage? {
        guard let mode = mode else {
            return nil
        }
        
        switch mode {
        case .user(let user):
            guard let imageName = user.avatarImageName else {
                return nil
            }
            
            return ImageUtility.loadImageFromDocuments(named: imageName)
            
        case .group(let group):
            guard let imageName = group.imageName else {
                return nil
            }
            
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }
    }
    
    // MARK: - Subviews
    
    private func profileImageView(_ image: UIImage) -> some View {
        Image(uiImage: profileImage!)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(borderOverlay)
    }
    
    private var initialsView: some View {
        Circle()
            .fill(backgroundColor)
            .frame(width: size, height: size)
            .overlay(
                Text(initials)
                    .font(font)
                    .foregroundColor(.white)
            )
            .overlay(borderOverlay)
    }
    
    private var borderOverlay: some View {
        Group {
            if let borderColor, let borderWidth {
                Circle().stroke(borderColor, lineWidth: borderWidth)
            }
        }
    }
}
