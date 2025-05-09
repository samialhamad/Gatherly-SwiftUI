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
        if let name = user?.bannerImageName ?? group?.bannerImageName {
            return ImageUtility.loadImageFromDocuments(named: name)
        }
        return nil
    }
    
    // MARK: - Subviews
    
    private func bannerView(bannerImage: UIImage) -> some View {
        BannerView(
            cornerRadius: 0,
            bottomPadding: 0, height: Constants.AvatarHeaderView.rectangleFrameHeight,
            image: bannerImage
        )
    }
}
