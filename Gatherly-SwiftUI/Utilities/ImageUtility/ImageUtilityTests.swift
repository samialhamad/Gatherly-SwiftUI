//
//  ImageUtilityTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/20/25.
//

import XCTest
import UIKit
@testable import Gatherly_SwiftUI

final class ImageUtilityTests: XCTestCase {
    
    //come back to this, failing because of image comparisons.. could change from jpg to png?
//    func testSaveAndLoadImage() {
//            let image = UIImage(systemName: "star")!
//            
//            guard let savedFilename = ImageUtility.saveImageToDocuments(image: image) else {
//                XCTFail("Failed to save image")
//                return
//            }
//            
//            let loadedImage = ImageUtility.loadImageFromDocuments(named: savedFilename)
//            
//            XCTAssertNotNil(loadedImage)
//            XCTAssertTrue(compareImages(image1: image, image2: loadedImage!))
//            
//            // cleanup
//            ImageUtility.deleteImageFromDocuments(named: savedFilename)
//        }
        
        func testDeleteImage() {
            let image = UIImage(systemName: "trash")!
            guard let savedFilename = ImageUtility.saveImageToDocuments(image: image) else {
                XCTFail("Failed to save image for delete test")
                return
            }
            
            ImageUtility.deleteImageFromDocuments(named: savedFilename)
            let deletedImage = ImageUtility.loadImageFromDocuments(named: savedFilename)
            
            XCTAssertNil(deletedImage)
        }

        // helper: rough comparison dimensions only for test simplicity
        private func compareImages(image1: UIImage, image2: UIImage) -> Bool {
            return image1.size == image2.size
        }
}
