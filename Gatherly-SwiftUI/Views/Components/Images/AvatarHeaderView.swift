//
//  AvatarHeaderView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct AvatarHeaderView: View {
    let user: User?
    let group: UserGroup?
    let size: CGFloat
    let font: Font
    let profileImage: UIImage?
    let bannerImage: UIImage?
    
    init(
        user: User? = nil,
        group: UserGroup? = nil,
        size: CGFloat = Constants.AvatarHeaderView.size,
        font: Font = .largeTitle,
        profileImage: UIImage? = nil,
        bannerImage: UIImage? = nil
    ) {
        self.user = user
        self.group = group
        self.size = size
        self.font = font
        self.profileImage = profileImage
        self.bannerImage = bannerImage
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if bannerImage != nil {
                bannerView
            } else {
                rectanglePlaceholderView
            }
            
            AvatarView(
                user: user,
                group: group,
                size: size,
                font: font,
                backgroundColor: Color(Colors.primary),
                borderColor: .white,
                borderWidth: Constants.AvatarHeaderView.avatarBorderWidth,
                profileImage: profileImage
            )
            .offset(y: Constants.AvatarHeaderView.offset)
        }
        .padding(.bottom, Constants.AvatarHeaderView.bottomPadding)
    }
}

private extension AvatarHeaderView {
    
    //MARK: - Subviews
    
    private var bannerView: some View {
        BannerView(
            uiImage: bannerImage,
            height: Constants.AvatarHeaderView.rectangleFrameHeight,
            cornerRadius: 0,
            paddingBottom: 0
        )
    }
    
    private var rectanglePlaceholderView: some View {
        Rectangle()
            .fill(Color(Colors.primary))
            .frame(height: Constants.AvatarHeaderView.rectangleFrameHeight)
    }
}
