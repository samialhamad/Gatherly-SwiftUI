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

    init(
        user: User? = nil,
        group: UserGroup? = nil,
        size: CGFloat = Constants.AvatarHeaderView.size,
        font: Font = .largeTitle
    ) {
        self.user = user
        self.group = group
        self.size = size
        self.font = font
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            //placeholder rectangle, will need to deal with image banners later
            Rectangle()
                .fill(Color(Colors.primary))
                .frame(height: Constants.AvatarHeaderView.rectangleFrameHeight)

            AvatarView(
                user: user,
                group: group,
                size: size,
                font: font,
                backgroundColor: Color(Colors.primary),
                borderColor: .white,
                borderWidth: Constants.AvatarHeaderView.avatarBorderWidth
            )
            .offset(y: Constants.AvatarHeaderView.offset)
        }
        .padding(.bottom, Constants.AvatarHeaderView.bottomPadding)
    }
}
