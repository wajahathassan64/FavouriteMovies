//
//  SearchMoviesViewModel.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//

import Foundation
import RxSwift
import RxDataSources

protocol SearchMoviesViewModelInputs {
    var loadNextPageObserver: AnyObserver<Void> { get }
    var cancelObserver: AnyObserver<Void>{ get }
    var searchInputTextObserver: AnyObserver<String?>{ get }
    var selectMovieObserver: AnyObserver<MovieResults>{ get }
}

protocol SearchMoviesViewModelOutputs {
    var cancel: Observable<Void>{ get }
    var error: Observable<String>{ get }
    var selectMovie: Observable<MovieResults>{ get }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

protocol SearchMoviesViewModelType {
    var inputs: SearchMoviesViewModelInputs { get }
    var outputs: SearchMoviesViewModelOutputs { get }
}

class SearchMoviesViewModel: SearchMoviesViewModelType, SearchMoviesViewModelInputs, SearchMoviesViewModelOutputs {

    //MARK: - Properties
    let disposeBag = DisposeBag()
    let searchDataProvider: SearchDataProviderType
    var inputs: SearchMoviesViewModelInputs { return self }
    var outputs: SearchMoviesViewModelOutputs { return self }
    
    private let errorSubject = PublishSubject<String>()
    private let cancelSubject = PublishSubject<Void>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let searchInputTextSubject = PublishSubject<String?>()
    private let selectMovieSubject = PublishSubject<MovieResults>()
    private let moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    
    //MARK: - Inputs
    var selectMovieObserver: AnyObserver<MovieResults>{ selectMovieSubject.asObserver() }
    var cancelObserver: AnyObserver<Void>{ cancelSubject.asObserver() }
    var searchInputTextObserver: AnyObserver<String?>{ searchInputTextSubject.asObserver() }
    
    //MARK: - Outputs
    var error: Observable<String> { errorSubject.asObservable() }
    var cancel: Observable<Void>{ cancelSubject.asObservable() }
    var selectMovie: Observable<MovieResults>{ selectMovieSubject.asObservable() }
    var loadNextPageObserver: AnyObserver<Void>{ loadNextPageSubject.asObserver() }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(searchDataProvider: SearchDataProviderType) {
        self.searchDataProvider = searchDataProvider
        makeCellViewModels()
        initialiseMoviesSubjetc()
    }
    
}

private extension SearchMoviesViewModel {
    func makeCellViewModels() {
        let cellViewModels = moviesSubject.unwrap().delay(.nanoseconds(100), scheduler: MainScheduler.instance)
            .map{ moviesList -> [ReusableTableViewCellViewModelType] in
            let viewModels = moviesList.map {  movieList -> ReusableTableViewCellViewModelType in
                let viewModel = MovieTableViewCellViewModelViewModel(movieResult: movieList)
                return viewModel
            }
            return viewModels
        }
        
        cellViewModels
            .map { [SectionModel(model: 1, items: $0)]}
            .bind(to: dataSourceSubject)
            .disposed(by: disposeBag)
        
    }
    
    func initialiseMoviesSubjetc() {
        
        loadNextPageSubject.subscribe(onNext: {[unowned self] _ in
            guard !self.searchDataProvider.isLastPage() else { return }
            self.searchDataProvider.fetchSubject.onNext(())
        }).disposed(by: disposeBag)
        
        searchInputTextSubject.unwrap().debounce(.seconds(1), scheduler: MainScheduler.instance).bind(to: searchDataProvider.searchMovieSubject).disposed(by: disposeBag)
        searchDataProvider.result.bind(to: moviesSubject).disposed(by: disposeBag)
        searchDataProvider.error.bind(to: errorSubject).disposed(by: disposeBag)
    }
}
