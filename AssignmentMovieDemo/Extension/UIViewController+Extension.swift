//
//  UIViewController+Extension.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 14/04/2021.
//

import Foundation
import RxSwift

extension UIViewController {
    func showAlert(title: String = "", message: String, defaultButtonTitle: String = "OK", secondayButtonTitle: String? = nil, defaultButtonHandler: ((UIAlertAction) -> Void)? = nil, secondaryButtonHandler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandler)
        alert.addAction(defaultAction)
        
        if secondayButtonTitle != nil {
            let secondaryAction = UIAlertAction(title: secondayButtonTitle, style: .cancel, handler: secondaryButtonHandler)
            alert.addAction(secondaryAction)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: completion)
        }
    }
}

extension UIViewController {
    public func addBackButton(tintColor: UIColor = .white) {
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.setImage(UIImage(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = tintColor
        button.backgroundColor = .clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.addTarget(self, action: #selector(onTapBackButton), for: .touchUpInside)
        
        let backButton = UIBarButtonItem()
        backButton.customView = button
        navigationItem.leftBarButtonItem  = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc open func onTapBackButton() {
        fatalError("Add back action in viewController")
    }
}

extension Reactive where Base: UIViewController {
    var showErrorMessage: Binder<String> {
        return Binder(base) { viewController, error in
            viewController.showAlert(message: error)
        }
    }
}
