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

public protocol ReusableTableViewCellViewModelType {
    var reusableIdentifier: String { get }
}

open class RxUITableViewCell: UITableViewCell, ReusableView {
    private(set) public var disposeBag = DisposeBag()
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    open func configure(with viewModel: Any) {
        fatalError("Configure with viewModel must be implemented.")
    }
    
}
