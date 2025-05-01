//
//  BannerView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/7/25.
//

import SwiftUI

struct BannerView: View {
    var bottomPadding: CGFloat = Constants.BannerView.bottomPadding
    var cornerRadius: CGFloat = Constants.BannerView.cornerRadius
    var height: CGFloat = Constants.BannerView.height
    var imageName: String?
    var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, bottomPadding)
            } else if let imageName = imageName,
                      let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName),
                      let loadedImage = UIImage(contentsOfFile: imageURL.path) {
                Image(uiImage: loadedImage)
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
}
