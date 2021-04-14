//
//  MovieCollectionViewCellViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

protocol MovieCollectionViewCellViewModelInputs {
    var favouriteIconTapObserver: AnyObserver<Void>{ get }
    var isFavouriteIconObserver: AnyObserver<Bool>{ get }
}

protocol MovieCollectionViewCellViewModelOutputs {
    var posterUrl: Observable<ImageWithURL>{ get }
    var name: Observable<String>{ get }
    var releaseDate: Observable<String>{ get }
    var storeFavourite: Observable<MovieResults>{ get }
    var isFavouriteIcon: Observable<Bool>{ get }
}

protocol MovieCollectionViewCellViewModelType {
    var inputs: MovieCollectionViewCellViewModelInputs { get }
    var outputs: MovieCollectionViewCellViewModelOutputs { get }
}

class MovieCollectionViewCellViewModel: ReusableCollectionViewCellViewModelType, MovieCollectionViewCellViewModelType, MovieCollectionViewCellViewModelInputs, MovieCollectionViewCellViewModelOutputs {
    
    var inputs: MovieCollectionViewCellViewModelInputs { return self }
    var outputs: MovieCollectionViewCellViewModelOutputs { return self }
    
    //MARK: - Properties
    let movieResult: MovieResults
    let disposeBag = DisposeBag()
    var reusableIdentifier: String { return MovieCollectionViewCell.reuseIdentifier }

    
    //MARK: - Subjects
    private let posterUrlSubject: BehaviorSubject<ImageWithURL>
    private let nameSubject: BehaviorSubject<String>
    private let releaseDateSubject: BehaviorSubject<String>
    private let favouriteIonTapSubject = PublishSubject<Void>()
    private let storeFavouriteSubject = PublishSubject<MovieResults>()
    private let isFavouriteIconSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var favouriteIconTapObserver: AnyObserver<Void>{ favouriteIonTapSubject.asObserver() }
    var isFavouriteIconObserver: AnyObserver<Bool>{ isFavouriteIconSubject.asObserver() }
    
    //MARK: - Outputs
    var posterUrl: Observable<ImageWithURL>{ posterUrlSubject.asObservable() }
    var name: Observable<String>{ nameSubject.asObservable() }
    var releaseDate: Observable<String>{ releaseDateSubject.asObservable() }
    var storeFavourite: Observable<MovieResults>{ storeFavouriteSubject.asObservable() }
    var isFavouriteIcon: Observable<Bool>{ isFavouriteIconSubject.asObservable() }
    
    //MARK: - Constructor/init
    
    init(movieResult: MovieResults) {
        self.movieResult = movieResult
        posterUrlSubject = BehaviorSubject(value: movieResult.posterImageWithUrl)
        nameSubject = BehaviorSubject(value: movieResult.title)
        releaseDateSubject = BehaviorSubject(value: movieResult.formattedReleaseDate)
        favouriteIonTapSubject.map{ self.movieResult }.bind(to: storeFavouriteSubject).disposed(by: disposeBag)
    }
    
}

