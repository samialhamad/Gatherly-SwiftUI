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
    var imageHeight: CGFloat = Constants.ImagePicker.imageHight
    var maskShape: MaskShape
    
    @Binding var selectedImage: UIImage?
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var showCropper = false
    @State private var imageToCrop: UIImage?
    
    var body: some View {
        Section(header: Text(title)) {
            VStack(alignment: .leading, spacing: Constants.ImagePicker.vstackSpacing) {
                if selectedImage != nil {
                    selectedImagePreview
                } else {
                    photoPickerButton
                }
            }
            .padding(.vertical, Constants.ImagePicker.vstackVerticalPadding)
            .fullScreenCover(isPresented: $showCropper) {
                cropperView
            }
        }
    }
}

private extension ImagePicker {
    
    // MARK: - Functions
    
    func cropConfig(for shape: MaskShape) -> SwiftyCropConfiguration {
        SwiftyCropConfiguration(
            maxMagnificationScale: 4.0,
            maskRadius: 130,
            cropImageCircular: shape == .circle,
            rotateImage: false,
            zoomSensitivity: 4.0,
            rectAspectRatio: 16 / 9
        )
    }
    
    // MARK: - Subviews
    
    var selectedImagePreview: some View {
        VStack(alignment: .leading, spacing: Constants.ImagePicker.vstackSpacing) {
            if let image = selectedImage {
                if maskShape == .circle {
                    HStack {
                        Spacer()
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: imageHeight, height: imageHeight)
                            .clipShape(Circle())
                        Spacer()
                    }
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: imageHeight)
                        .clipped()
                        .cornerRadius(Constants.ImagePicker.cornerRadius)
                }
            }
            
            Button("Remove Image") {
                selectedImage = nil
            }
            .foregroundColor(Color(Colors.primary))
            .padding(.top, Constants.ImagePicker.topPadding)
        }
    }
    
    var photoPickerButton: some View {
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
            .tint(Color(Colors.primary))
    }
    
    var cropperView: some View {
        Group {
            if let imageToCrop {
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
}
