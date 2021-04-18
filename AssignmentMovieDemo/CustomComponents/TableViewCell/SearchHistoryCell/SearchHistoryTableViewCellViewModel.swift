//
//  SearchHistoryTableViewCellViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 18/04/2021.
//

import Foundation
import RxSwift

protocol SearchHistoryTableViewCellViewModelInputs {
    var isHideHeadingObserver: AnyObserver<Bool>{ get }
}

protocol SearchHistoryTableViewCellViewModelOutputs {
    var title: Observable<String>{ get }
    var isHideHeading: Observable<Bool>{ get }
}

protocol SearchHistoryTableViewCellViewModelType {
    var inputs: SearchHistoryTableViewCellViewModelInputs { get }
    var outputs: SearchHistoryTableViewCellViewModelOutputs { get }
}

class SearchHistoryTableViewCellViewModel: SearchHistoryTableViewCellViewModelType, SearchHistoryTableViewCellViewModelInputs, SearchHistoryTableViewCellViewModelOutputs, ReusableTableViewCellViewModelType {
    
    //MARK: - Properties
    let query: String
    let disposeBag = DisposeBag()
    var reusableIdentifier: String { return SearchHistoryTableViewCell.reuseIdentifier }
    var inputs: SearchHistoryTableViewCellViewModelInputs { return self }
    var outputs: SearchHistoryTableViewCellViewModelOutputs { return self }
    
    private let titleSubject: BehaviorSubject<String>
    private let isHideHeadingSubject: BehaviorSubject<Bool>
    
    //MARK: - Inputs
    var isHideHeadingObserver: AnyObserver<Bool>{ isHideHeadingSubject.asObserver()}
    
    //MARK: - Outputs
    var title: Observable<String>{ titleSubject.asObservable() }
    var isHideHeading: Observable<Bool>{ isHideHeadingSubject.asObservable()}
    
    //MARK: - Constructor/init
    init(query: String, isHideHeading: Bool) {
        self.query = query
        titleSubject = BehaviorSubject(value: self.query)
        isHideHeadingSubject = BehaviorSubject(value: isHideHeading)
    }
    
}

