//
//  ImagePicker.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/2/25.
//

import SwiftUI
import PhotosUI
import SwiftyCrop

struct ImagePicker: View {
    let title: String
    var imageHeight: CGFloat = 150
    var maskShape: MaskShape
    
    @Binding var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showCropper = false
    @State private var imageToCrop: UIImage?
    
    var body: some View {
        Section(header: Text(title)) {
            VStack(alignment: .leading, spacing: 8) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: imageHeight)
                        .clipped()
                        .cornerRadius(10)
                    
                    Button("Remove Image") {
                        selectedImage = nil
                    }
                    .foregroundColor(Color(Colors.primary))
                    .padding(.top, 5)
                } else {
                    PhotosPicker("Select Image", selection: $selectedPhotoItem, matching: .images)
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    imageToCrop = uiImage
                                    showCropper = true
                                }
                            }
                        }
                        .foregroundColor(Color(Colors.primary))
                }
            }
            .padding(.vertical, 4)
        }
        .fullScreenCover(isPresented: $showCropper) {
            if let imageToCrop = imageToCrop {
                SwiftyCropView(
                    imageToCrop: imageToCrop,
                    maskShape: maskShape,
                    configuration: cropConfig(for: maskShape)
                ) { cropped in
                    selectedImage = cropped
                    showCropper = false
                }
            }
        }
    }
    
    private func cropConfig(for shape: MaskShape) -> SwiftyCropConfiguration {
        SwiftyCropConfiguration(
            maxMagnificationScale: 4.0,
            maskRadius: 130,
            cropImageCircular: shape == .circle,
            rotateImage: false,
            zoomSensitivity: 4.0,
            rectAspectRatio: 16 / 9 // for .rectangle only
        )
    }
}
