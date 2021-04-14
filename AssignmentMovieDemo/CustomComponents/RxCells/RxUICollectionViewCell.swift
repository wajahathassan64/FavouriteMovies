//
//  RxUICollectionViewCell.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import UIKit
import RxSwift
import WHCustomizeConstraint

open class RxUICollectionViewCell: UICollectionViewCell, ReusableView {
    
    private(set) public var disposeBag = DisposeBag()
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    open func configure(with viewModel: Any) {
        fatalError("Configure with viewModel must be implemented.")
    }
    
}
