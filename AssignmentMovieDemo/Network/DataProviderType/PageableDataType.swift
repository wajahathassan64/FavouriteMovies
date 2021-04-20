//
//  PageableDataType.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

protocol PageableDataType {
    func isLastPage() -> Bool
    var error: Observable<String>{ get }
    var fetchSubject: PublishSubject<Void>{ get }
    var result: Observable<[MovieResults]?>{ get }
}

