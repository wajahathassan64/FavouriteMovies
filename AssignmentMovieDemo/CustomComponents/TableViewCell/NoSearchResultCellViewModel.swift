//
//  NoSearchResultCellViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 17/04/2021.
//

import Foundation
import RxSwift

protocol NoSearchResultCellViewModelInput {
    
}

protocol NoSearchResultCellViewModelOutput {
    var title: Observable<String?> { get }
}

protocol NoSearchResultCellViewModelType {
    var inputs: NoSearchResultCellViewModelInput { get }
    var outputs: NoSearchResultCellViewModelOutput { get }
}

class NoSearchResultCellViewModel: NoSearchResultCellViewModelType, NoSearchResultCellViewModelInput, NoSearchResultCellViewModelOutput, ReusableTableViewCellViewModelType {
    
    // MARK: - Properties
    let disposeBag = DisposeBag()
    var inputs: NoSearchResultCellViewModelInput { return self }
    var outputs: NoSearchResultCellViewModelOutput { return self }
    var reusableIdentifier: String { return NoSearchResultCell.reuseIdentifier }
    
    private let titleSubject: BehaviorSubject<String?>
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var title: Observable<String?> { titleSubject.asObservable() }
    
    // MARK: - Init
    public init(title: String = "No results") {
        titleSubject = BehaviorSubject(value: title)
    }
}
