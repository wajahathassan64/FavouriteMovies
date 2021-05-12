//
//  ImageCashingManager.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 12/05/2021.
//

import Foundation
import SDWebImage

class ImageCashingManager {
    
    func clearMemory() {
        SDWebImageManager.shared.imageCache.clear(with: .memory) {
            print("Clearing memory")
        }
    }
}
