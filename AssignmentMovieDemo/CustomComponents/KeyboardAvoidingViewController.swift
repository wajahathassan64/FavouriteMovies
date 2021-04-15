//
//  KeyboardAvoidingViewController.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 16/04/2021.
//

import Foundation
import UIKit

// MARK: Keyboard handling

open class KeyboardAvoidingViewController: UIViewController {
    
    private var constant: CGFloat = 0
    private var keyboardConstraint: NSLayoutConstraint?
    public var keyboardAvoidingBottomOffset: CGFloat = 0
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard UIScreen.main.bounds.size.height != 568 else { return }
        
        keyboardConstraint = view.constraints.filter{ $0.identifier == "keyboardAvoidingConstraint" }.first
        constant = keyboardConstraint?.constant ?? 0
        
        if keyboardAvoidingBottomOffset == 0 {
            keyboardAvoidingBottomOffset = view.safeAreaInsets.bottom
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

private extension KeyboardAvoidingViewController {

    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let constraint = keyboardConstraint else { return }
                
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            constraint.constant = keyboardSize.height + 15 - keyboardAvoidingBottomOffset
            UIView.animate(withDuration: 0.25) { [unowned self] in
                self.view.layoutAllSubviews()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        
        guard let constraint = keyboardConstraint else { return }
        
        constraint.constant = constant
        UIView.animate(withDuration: 0.25) { [unowned self] in
            self.view.layoutAllSubviews()
        }
    }
}
