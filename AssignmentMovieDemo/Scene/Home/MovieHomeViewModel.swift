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
}

protocol MovieHomeViewModelOutputs {
    var actionFavouriteMovies: Observable<Void>{ get }
    var actionSearchMovies: Observable<Void>{ get }
    var movies: Observable<[MovieResults]?>{ get }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { get }
    var error: Observable<String>{ get }
    var isFavouriteMovieRemove: Observable<Void>{ get }
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
   internal let errorSubject = PublishSubject<String>()
   internal let loadNextPageSubject = PublishSubject<Void>()
   internal let actionSearchMoviesSubject = PublishSubject<Void>()
   internal let actionFavouriteMoviesSubject = PublishSubject<Void>()
   internal let moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
   internal let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]>(value: [])
   internal let isFavouriteMovieRemoveSubject = PublishSubject<Void>()
    
    //MARK: - Inputs
    var loadNextPageObserver: AnyObserver<Void>{ loadNextPageSubject.asObserver() }
    var actionFavouriteMoviesObserver: AnyObserver<Void>{ actionFavouriteMoviesSubject.asObserver() }
    var actionSearchMoviesObserver: AnyObserver<Void>{ actionSearchMoviesSubject.asObserver() }
    var isFavouriteMovieRemoveObserver: AnyObserver<Void>{ isFavouriteMovieRemoveSubject.asObserver() }
    
    //MARK: - Outputs
    var error: Observable<String>{ errorSubject.asObservable() }
    var actionFavouriteMovies: Observable<Void>{ actionFavouriteMoviesSubject.asObservable() }
    var actionSearchMovies: Observable<Void>{ actionSearchMoviesSubject.asObservable() }
    var movies: Observable<[MovieResults]?>{ moviesSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    var isFavouriteMovieRemove: Observable<Void>{ isFavouriteMovieRemoveSubject.asObservable() }
    
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
    
        let cellViewModels = moviesSubject.unwrap().delay(.nanoseconds(1), scheduler: MainScheduler.asyncInstance)
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
