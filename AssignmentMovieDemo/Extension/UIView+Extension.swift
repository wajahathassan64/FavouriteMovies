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
}
