//
//  UIImageView+Extenstion.swift
////  AssignmentMovieDemo
////
////  Created by Wajahat Hassan on 10/04/2021.

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SDWebImage


public typealias ImageWithURL = (String?, UIImage?)

// MARK: Image loading
public extension UIImageView {
    func loadImage(with url: URL?, placeholder: UIImage? = nil, showsIndicator: Bool = false) {
        sd_imageIndicator = showsIndicator ? SDWebImageActivityIndicator.grayLarge : nil
        sd_setImage(with: url, placeholderImage: placeholder)
    }
    
}

public extension Reactive where Base: UIImageView {
    func loadImage(_ showsIndicator: Bool = false) -> Binder<ImageWithURL> {
        return Binder(self.base) { imageView, params -> Void in
            imageView.loadImage(with: URL(string: params.0 ?? ""), placeholder: params.1, showsIndicator: showsIndicator)
        }
    }
    
}
