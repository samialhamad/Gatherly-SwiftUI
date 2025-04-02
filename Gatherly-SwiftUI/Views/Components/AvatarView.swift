//
//  AvatarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/25/25.
//

import SwiftUI

struct AvatarView: View {
    let user: User?
    let group: UserGroup?
    let size: CGFloat
    let font: Font
    let backgroundColor: Color
    let borderColor: Color?
    let borderWidth: CGFloat?
    let profileImage: UIImage?
    
    init(
        user: User? = nil,
        group: UserGroup? = nil,
        size: CGFloat,
        font: Font,
        backgroundColor: Color,
        borderColor: Color? = nil,
        borderWidth: CGFloat? = nil,
        profileImage: UIImage? = nil
    ) {
        self.user = user
        self.group = group
        self.size = size
        self.font = font
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.profileImage = profileImage
    }
    
    var body: some View {
        if profileImage != nil {
            profileImageView
        } else {
            initialsView
        }
    }
}

private extension AvatarView {
    
    //MARK: - Computed vars
    
    private var initials: String {
        if let user = user {
            let firstInitial = user.firstName?.first.map(String.init) ?? ""
            let lastInitial = user.lastName?.first.map(String.init) ?? ""
            return firstInitial + lastInitial
        } else if let group = group {
            return group.name.first.map { String($0).uppercased() } ?? "?"
        } else {
            return ""
        }
    }
    
    //MARK: - Subviews
    
    private var profileImageView: some View {
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
            if let borderColor = borderColor, let borderWidth = borderWidth {
                Circle().stroke(borderColor, lineWidth: borderWidth)
            }
        }
    }
}
