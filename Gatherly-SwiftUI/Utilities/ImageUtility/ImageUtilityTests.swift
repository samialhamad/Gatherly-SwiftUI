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
    
    func testSaveAndLoadImage() {
        let image = UIImage(systemName: "star")!
        
        guard let filename = ImageUtility.saveImageToDocuments(image: image) else {
            XCTFail("Failed to save image")
            return
        }
        
        let loadedImage = ImageUtility.loadImageFromDocuments(named: filename)
        
        XCTAssertNotNil(loadedImage)
    }
    
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
}
