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
    let refreshID: UUID
    
    init(
        user: User? = nil,
        group: UserGroup? = nil,
        size: CGFloat = Constants.AvatarHeaderView.size,
        font: Font = .largeTitle,
        refreshID: UUID = UUID()
    ) {
        self.user = user
        self.group = group
        self.size = size
        self.font = font
        self.refreshID = refreshID
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let bannerImage = bannerImage {
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
        if let user = user, let imageName = user.avatarImageName {
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }
        if let group = group, let imageName = group.imageName {
            return ImageUtility.loadImageFromDocuments(named: imageName)
        }
        return nil
    }
    
    private var bannerImage: UIImage? {
        if let user = user, let bannerName = user.bannerImageName {
            return ImageUtility.loadImageFromDocuments(named: bannerName)
        }
        if let group = group, let bannerName = group.bannerImageName {
            return ImageUtility.loadImageFromDocuments(named: bannerName)
        }
        return nil
    }
    
    // MARK: - Subviews
    
    private func bannerView(bannerImage: UIImage) -> some View {
        BannerView(
            uiImage: bannerImage,
            height: Constants.AvatarHeaderView.rectangleFrameHeight,
            cornerRadius: 0,
            bottomPadding: 0
        )
    }
}
