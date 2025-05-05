//
//  AvatarHeaderView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct AvatarHeaderView: View {
    let font: Font
    let group: UserGroup?
    let refreshID: UUID
    let size: CGFloat
    let user: User?
    
    init(
        font: Font = .largeTitle,
        group: UserGroup? = nil,
        refreshID: UUID = UUID(),
        size: CGFloat = Constants.AvatarHeaderView.size,
        user: User? = nil
    ) {
        self.font = font
        self.group = group
        self.refreshID = refreshID
        self.size = size
        self.user = user
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let bannerImage {
                bannerView(bannerImage: bannerImage)
                    .frame(height: Constants.AvatarHeaderView.rectangleFrameHeight)
            }
            
            AvatarView(
                backgroundColor: Color(Colors.primary),
                borderColor: .white,
                borderWidth: Constants.AvatarHeaderView.avatarBorderWidth,
                font: font,
                group: group,
                size: size,
                user: user
            )
            .padding(.top, bannerImage == nil ? Constants.AvatarHeaderView.bannerImageTopPadding : -size / 2)
        }
        .id(refreshID)
        .padding(.bottom, Constants.AvatarHeaderView.bottomPadding)
    }
}

private extension AvatarHeaderView {
    
    // MARK: - Computed Vars
    
    private var profileImage: UIImage? {
        if let user, let imageName = user.avatarImageName {
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }
        if let group, let imageName = group.imageName {
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }
        return nil
    }
    
    private var bannerImage: UIImage? {
        if let user, let bannerName = user.bannerImageName {
            return ImageUtility.loadImageFromDocuments(named: bannerName)
        }
        if let group, let bannerName = group.bannerImageName {
            return ImageUtility.loadImageFromDocuments(named: bannerName)
        }
        return nil
    }
    
    // MARK: - Subviews
    
    private func bannerView(bannerImage: UIImage) -> some View {
        BannerView(
            bottomPadding: 0,
            cornerRadius: 0,
            height: Constants.AvatarHeaderView.rectangleFrameHeight,
            uiImage: bannerImage
        )
    }
}
