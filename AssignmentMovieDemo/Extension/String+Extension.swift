//
//  String+Extension.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import UIKit

extension String {
    
    func initialsImage(color: UIColor, size: CGSize = CGSize(width: 200, height: 200)) -> UIImage {
        return initialsImage(backgroundColor: color.withAlphaComponent(0.15), textColor: color, size: size)
    }
    
    func initialsImage(backgroundColor: UIColor, textColor: UIColor, size: CGSize = CGSize(width: 200, height: 200)) -> UIImage {
        let nameLabel = UILabel()
        nameLabel.frame.size = size
        nameLabel.textColor = textColor
        
        let comps = components(separatedBy: .whitespaces).filter({ !$0.isEmpty })
        nameLabel.text = [comps.first?.first?.uppercased(), comps.last?.first?.uppercased()].compactMap({ $0 }).joined()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.backgroundColor = backgroundColor
        
        UIGraphicsBeginImageContext(nameLabel.frame.size)
        nameLabel.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let data = newImage?.jpegData(compressionQuality: 1.0) else { return newImage! }
        
        return UIImage.init(data: data)!
    }
}
