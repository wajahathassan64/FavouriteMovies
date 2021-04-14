//
//  UIColor+Extension.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import UIKit
extension UIColor {
    static func colorFor(listItemIndex: Int) -> UIColor {
        switch listItemIndex % 6 {
        case 0: return .orange
        case 1: return .green
        case 2: return .gray
        case 3: return .darkGray
        case 4: return .lightGray
        default: return .orange
        }
    }
    
    static func randomColor()-> UIColor {
        colorFor(listItemIndex: Int.random(in: 0...5))
    }
}
