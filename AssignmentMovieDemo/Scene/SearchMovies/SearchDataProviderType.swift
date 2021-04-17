//
//  SearchDataProviderType.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//

import Foundation
import RxSwift


protocol SearchInputType {
    var searchMovieSubject: BehaviorSubject<String?>{ get }
    var reloadDataSubject: PublishSubject<Void>{ get }
}

protocol SearchDataProviderType: MovieDataProviderType & SearchInputType { }
