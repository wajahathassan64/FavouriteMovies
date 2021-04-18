//
//  FavouriteMovieViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation
import RxSwift
import RxDataSources

protocol FavouriteMovieViewModelInputs { }

protocol FavouriteMovieViewModelOutputs {
    var movies: Observable<[MovieResults]?>{ get }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

protocol FavouriteMovieViewModelType {
    var inputs: FavouriteMovieViewModelInputs { get }
    var outputs: FavouriteMovieViewModelOutputs { get }
}

class FavouriteMovieViewModel: FavouriteMovieViewModelType, FavouriteMovieViewModelInputs, FavouriteMovieViewModelOutputs {
    
    //MARK: - Properties
    let storeDataManager: FavouriteMoviesDataManager
    var isFavouriteMovieRemove: AnyObserver<Void>!
    let disposeBag = DisposeBag()
    
    var inputs: FavouriteMovieViewModelInputs { return self }
    var outputs: FavouriteMovieViewModelOutputs { return self }
    
    //MARK: - Subjects
    private let loadNextPageSubject = PublishSubject<Void>()
    private let moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    
    //MARK: - Inputs
    
    //MARK: - Outputs
    var movies: Observable<[MovieResults]?>{ moviesSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(storeDataManager: FavouriteMoviesDataManager, isFavouriteMovieRemove: AnyObserver<Void>) {
        self.storeDataManager = storeDataManager
        self.isFavouriteMovieRemove = isFavouriteMovieRemove
        makeCellViewModels()
        fetchMovieListdb()
        refreshCellViewModels()
    }
}

private extension FavouriteMovieViewModel {
    func makeCellViewModels() {
        let cellViewModels = moviesSubject.unwrap().delay(.nanoseconds(100), scheduler: MainScheduler.instance)
            .map{ [unowned self] moviesList -> [ReusableTableViewCellViewModelType] in
                let viewModels = moviesList.map { [unowned self] movieList -> ReusableTableViewCellViewModelType in
                    let viewModel = MovieTableViewCellViewModel(movieResult: movieList)
                    
                    viewModel.outputs.favourite.subscribe(onNext:{[weak self] movie in
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
    
    func fetchMovieListdb() {
        guard let movies = storeDataManager.fetchFavouriteMovie() else { return }
        moviesSubject.onNext(movies.reversed())
    }
    
    func refreshCellViewModels() {
        self.storeDataManager.successSubject.subscribe(onNext: {[weak self] _ in
            self?.fetchMovieListdb()
            self?.isFavouriteMovieRemove.onNext(())
        }).disposed(by: disposeBag)
    }
}
