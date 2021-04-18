//
//  UIView+Extension.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import UIKit

// This particular extension not written by me
protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView {
    func layoutAllSubviews() {
        subviews.forEach{ $0.layoutAllSubviews() }
        layoutSubviews()
    }
    
    func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
        layer.cornerRadius = bounds.height/2
        layer.borderWidth = width ?? 0
        layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
        layer.masksToBounds = false
        clipsToBounds = true
    }
}
