//
//  AvatarHeaderView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import SwiftUI

struct AvatarHeaderView: View {
    
    typealias Mode = AvatarView.Mode
    
    let font: Font
    let refreshID: UUID
    let size: CGFloat
    let mode: Mode
    
    init(
        font: Font = .largeTitle,
        refreshID: UUID = UUID(),
        size: CGFloat = Constants.AvatarHeaderView.size,
        mode: Mode
    ) {
        self.font = font
        self.refreshID = refreshID
        self.size = size
        self.mode = mode
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
                size: size,
                mode: mode
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
    
    private var bannerImage: UIImage? {
        switch mode {
        case .user(let user):
            guard let bannerImageName = user.bannerImageName else {
                return nil
            }
            
            return ImageUtility.loadImageFromDocuments(named: bannerImageName)
            
        case .group(let group):
            guard let bannerImageName = group.bannerImageName else {
                return nil
            }
            
            return ImageUtility.loadImageFromDocuments(named: bannerImageName)
        }
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
