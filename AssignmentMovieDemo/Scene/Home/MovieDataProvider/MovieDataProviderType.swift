//
//  MovieDataProviderType.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

protocol MovieDataProviderType {
    var result: Observable<[MovieResults]?>{ get }
    var error: Observable<String>{ get }
    var fetchSubject: PublishSubject<Void>{ get }
    func isLastPage() -> Bool
}
