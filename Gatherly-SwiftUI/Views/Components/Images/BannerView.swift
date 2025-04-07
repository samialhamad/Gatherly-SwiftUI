//
//  BannerView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/7/25.
//

import SwiftUI

struct BannerView: View {
    var uiImage: UIImage?
    var imageName: String?
    var height: CGFloat = 200
    var cornerRadius: CGFloat = 12
    var paddingBottom: CGFloat = 8

    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, paddingBottom)
            } else if let imageName = imageName,
                      let imageURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageName),
                      let loadedImage = UIImage(contentsOfFile: imageURL.path) {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: height)
                    .clipped()
                    .cornerRadius(cornerRadius)
                    .padding(.bottom, paddingBottom)
            } else {
                EmptyView()
            }
        }
    }
}
