//
//  MovieSearchTextField.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//

import Foundation
import UIKit

//This class not written by me.
public class AppSearchTextField: UITextField {
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "icon_search")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        imageView.contentMode = .center
        leftView = imageView
        leftViewMode = .always
        
    }
}

// MARK: Drawing

extension AppSearchTextField {
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return isFirstResponder ? rect(forBounds: bounds) : CGRect(x: bounds.size.width/2 - (((placeholder as NSString?)?.size(withAttributes: [.font: font ?? UIFont.systemFont(ofSize: 14)]).width ?? 0)/2), y: 0, width: bounds.width, height: bounds.height)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return rect(forBounds: bounds)
    }
    
    private func rect(forBounds bounds: CGRect) -> CGRect {
        var rect = bounds
        rect.origin.x += bounds.height
        rect.size.width -= 1.5 * bounds.height
        return rect
    }
    
    public override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let x = isFirstResponder || text?.count ?? 0 > 0 ? 0 : bounds.size.width/2 - (((placeholder as NSString?)?.size(withAttributes: [.font: font ?? UIFont.systemFont(ofSize: 14)]).width ?? 0)/2) - bounds.height
        
        return CGRect(x: x, y: 0, width: bounds.height, height: bounds.height)
    }
}
