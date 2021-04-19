//
//  MovieHomeViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift
import RxDataSources

protocol MovieHomeViewModelInputs {
    var loadNextPageObserver: AnyObserver<Void> { get }
    var actionFavouriteMoviesObserver: AnyObserver<Void>{ get }
    var actionSearchMoviesObserver: AnyObserver<Void>{ get }
    var isFavouriteMovieRemoveObserver: AnyObserver<Void>{ get }
    var selectMovieObserver: AnyObserver<MovieResults>{ get }
}

protocol MovieHomeViewModelOutputs {
    var actionFavouriteMovies: Observable<Void>{ get }
    var actionSearchMovies: Observable<Void>{ get }
    var movies: Observable<[MovieResults]?>{ get }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { get }
    var error: Observable<String>{ get }
    var isFavouriteMovieRemove: Observable<Void>{ get }
    var selectMovie: Observable<MovieResults>{ get }
}

protocol MovieHomeViewModelType {
    var inputs: MovieHomeViewModelInputs { get }
    var outputs: MovieHomeViewModelOutputs { get }
}

class MovieHomeViewModel: MovieHomeViewModelType, MovieHomeViewModelInputs, MovieHomeViewModelOutputs {
    
    //MARK: - Properties
    let storeDataManager: FavouriteMoviesDataManagerType
    let movieDataProvider: MovieDataProviderType
    let disposeBag = DisposeBag()
    
    var inputs: MovieHomeViewModelInputs { return self }
    var outputs: MovieHomeViewModelOutputs { return self }
    
    //MARK: - Subjects
    private let errorSubject = PublishSubject<String>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let actionSearchMoviesSubject = PublishSubject<Void>()
    private let actionFavouriteMoviesSubject = PublishSubject<Void>()
    private let moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]>(value: [])
    private let isFavouriteMovieRemoveSubject = PublishSubject<Void>()
    private let selectMovieSubject = PublishSubject<MovieResults>()
    
    //MARK: - Inputs
    var loadNextPageObserver: AnyObserver<Void>{ loadNextPageSubject.asObserver() }
    var actionFavouriteMoviesObserver: AnyObserver<Void>{ actionFavouriteMoviesSubject.asObserver() }
    var actionSearchMoviesObserver: AnyObserver<Void>{ actionSearchMoviesSubject.asObserver() }
    var isFavouriteMovieRemoveObserver: AnyObserver<Void>{ isFavouriteMovieRemoveSubject.asObserver() }
    var selectMovieObserver: AnyObserver<MovieResults>{ selectMovieSubject.asObserver() }
    
    //MARK: - Outputs
    var error: Observable<String>{ errorSubject.asObservable() }
    var actionFavouriteMovies: Observable<Void>{ actionFavouriteMoviesSubject.asObservable() }
    var actionSearchMovies: Observable<Void>{ actionSearchMoviesSubject.asObservable() }
    var movies: Observable<[MovieResults]?>{ moviesSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    var isFavouriteMovieRemove: Observable<Void>{ isFavouriteMovieRemoveSubject.asObservable() }
    var selectMovie: Observable<MovieResults>{ selectMovieSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(storeDataManager: FavouriteMoviesDataManagerType, movieDataProvider: MovieDataProviderType) {
        self.storeDataManager = storeDataManager
        self.movieDataProvider = movieDataProvider
        makeCellViewModels()
        requestSubjectInit()
        storeDataManagerObserver()
        removeFavouriteMovieObserver()
    }
    
}

private extension MovieHomeViewModel {
    
    func makeCellViewModels() {
        
        let cellViewModels = moviesSubject.unwrap().observe(on: MainScheduler.asyncInstance)
            .map{ [unowned self] moviesList -> [ReusableCollectionViewCellViewModelType] in
                
                let viewModels = moviesList.map { [unowned self] movieList -> ReusableCollectionViewCellViewModelType in
                    let viewModel = MovieCollectionViewCellViewModel(movieResult: movieList)
                    
                    viewModel.outputs.storeFavourite.subscribe(onNext:{[weak self] movie in
                        self?.storeDataManager.storeFavouriteMovie(movie: movie)
                    }).disposed(by: disposeBag)
                    
                    if let movies = storeDataManager.fetchFavouriteMovie() {
                        let isFavourite = movies.filter{ $0.id == viewModel.movieResult.id }.first.map{ _ in true  }
                        viewModel.inputs.isFavouriteIconObserver.onNext(isFavourite ?? false)
                    }
                    
                    return viewModel
                }
                return viewModels
            }
        
        cellViewModels
            .map { [SectionModel(model: 1, items: $0)]}
            .bind(to: dataSourceSubject)
            .disposed(by: disposeBag)
    }
    
    
    func requestSubjectInit() {
        //data
        movieDataProvider.result.bind(to: moviesSubject).disposed(by: disposeBag)
        //error
        movieDataProvider.error.bind(to: errorSubject).disposed(by: disposeBag)
        //load next
        loadNextPageSubject.subscribe(onNext: {[unowned self] _ in
            guard !self.movieDataProvider.isLastPage() else { return }
            self.movieDataProvider.fetchSubject.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func storeDataManagerObserver() {
        storeDataManager.successSubject.subscribe(onNext: {[weak self] _ in
            self?.makeCellViewModels()
        }).disposed(by: disposeBag)
    }
    
    func removeFavouriteMovieObserver() {
        isFavouriteMovieRemove.subscribe(onNext: {[weak self] _ in
            self?.makeCellViewModels()
        }).disposed(by: disposeBag)
    }
}
