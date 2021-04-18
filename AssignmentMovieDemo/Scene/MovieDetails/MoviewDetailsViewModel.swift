//
//  MoviewDetailsViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 18/04/2021.
//

import Foundation
import RxSwift

protocol MovieDetailsViewModelInputs {
    var actionFavouriteIcon: AnyObserver<Void>{ get }
    var backObserver: AnyObserver<Void>{ get }
}

protocol MovieDetailsViewModelOutputs {
    
    var coverImage: Observable<ImageWithURL?>{ get }
    var posterImage: Observable<ImageWithURL?>{ get }
    var movieTitle: Observable<String?>{ get }
    var movieOverview: Observable<String?>{ get }
    var movieReleaseDate: Observable<String?>{ get }
    var isFavouriteIcon: Observable<Bool>{ get }
    var back: Observable<Void>{ get }
}

protocol MovieDetailsViewModelType {
    var inputs: MovieDetailsViewModelInputs { get }
    var outputs: MovieDetailsViewModelOutputs { get }
}

class MovieDetailsViewModel: MovieDetailsViewModelType, MovieDetailsViewModelInputs, MovieDetailsViewModelOutputs {
    
    
    //MARK: - Properties
    let movie: MovieResults
    let disposeBag = DisposeBag()
    var isFavouriteMovieRemove: AnyObserver<Void>
    let storeDataManager: FavouriteMoviesDataManagerType
    var inputs: MovieDetailsViewModelInputs { return self }
    var outputs: MovieDetailsViewModelOutputs { return self }
    
    private let backSubject = PublishSubject<Void>()
    private let coverImageSubject = BehaviorSubject<ImageWithURL?>(value: nil)
    private let posterImageSubject = BehaviorSubject<ImageWithURL?>(value: nil)
    private let movieTitleSubject = BehaviorSubject<String?>(value: nil)
    private let movieOverviewSubject = BehaviorSubject<String?>(value: nil)
    private let movieReleaseDateSubject = BehaviorSubject<String?>(value: nil)
    private let actionFavouriteIconSubject = PublishSubject<Void>()
    private let isFavouriteIconSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var actionFavouriteIcon: AnyObserver<Void>{ actionFavouriteIconSubject.asObserver() }
    var backObserver: AnyObserver<Void>{ backSubject.asObserver() }
    
    //MARK: - Outputs
    var back: Observable<Void>{ backSubject.asObservable() }
    var coverImage: Observable<ImageWithURL?>{ coverImageSubject.asObservable() }
    var posterImage: Observable<ImageWithURL?>{ posterImageSubject.asObservable() }
    var movieTitle: Observable<String?>{ movieTitleSubject.asObservable() }
    var movieOverview: Observable<String?>{ movieOverviewSubject.asObservable() }
    var movieReleaseDate: Observable<String?>{ movieReleaseDateSubject.asObservable() }
    var isFavouriteIcon: Observable<Bool>{ isFavouriteIconSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(movie: MovieResults, storeDataManager: FavouriteMoviesDataManager, isFavouriteMovieRemove: AnyObserver<Void>) {
        self.movie = movie
        self.isFavouriteMovieRemove = isFavouriteMovieRemove
        self.storeDataManager = storeDataManager
        posterImageSubject.onNext(movie.posterImageWithUrl)
        coverImageSubject.onNext(movie.bannerImageWithUrl)
        movieTitleSubject.onNext(movie.title)
        movieReleaseDateSubject.onNext(movie.releaseDate)
        movieOverviewSubject.onNext(movie.overview)
        storeDataManagerObserver()
        setFavouriteIconState()
    }
    
}

extension MovieDetailsViewModel {
    
    func storeDataManagerObserver() {
        actionFavouriteIconSubject.subscribe(onNext:{[unowned self] _ in
            self.storeDataManager.storeFavouriteMovie(movie: movie)
            self.setFavouriteIconState()
        }).disposed(by: disposeBag)
        
        storeDataManager.successSubject.subscribe(onNext: {[unowned self] _ in
            self.isFavouriteMovieRemove.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func setFavouriteIconState() {
        if let movies = storeDataManager.fetchFavouriteMovie() {
            let isFavourite = movies.filter{ $0.id == movie.id }.first.map{ _ in true  }
            isFavouriteIconSubject.onNext(isFavourite ?? false)
        }
    }
    
}
