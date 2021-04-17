//
//  File.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation
import UIKit
import RxSwift
import WHCustomizeConstraint

protocol ReusableTableViewCellViewModelType {
    var reusableIdentifier: String { get }
}

class RxUITableViewCell: UITableViewCell, ReusableView {
    private(set) public var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(with viewModel: Any) {
        fatalError("Configure with viewModel must be implemented.")
    }
    
}
