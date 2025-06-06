//
//  BannerView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/7/25.
//

import SwiftUI

struct BannerView: View {
    var cornerRadius: CGFloat = Constants.BannerView.cornerRadius
    var bottomPadding: CGFloat = Constants.BannerView.bottomPadding
    var height: CGFloat = Constants.BannerView.height
    var image: UIImage?

    var body: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: height)
                .clipped()
                .cornerRadius(cornerRadius)
                .padding(.bottom, bottomPadding)
        } else {
            EmptyView()
        }
    }
}
