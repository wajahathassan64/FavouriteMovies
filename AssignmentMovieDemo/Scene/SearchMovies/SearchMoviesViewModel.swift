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
    var onTapSearchButtonObserver: AnyObserver<Void>{ get }
    var emptyStringObserver: AnyObserver<Void>{ get }
    var reloadDataObserver: AnyObserver<Void>{ get }
}

protocol SearchMoviesViewModelOutputs {
    var cancel: Observable<Void>{ get }
    var error: Observable<String>{ get }
    var selectMovie: Observable<MovieResults>{ get }
    var reloadMovieData: Observable<Void>{ get }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
}

protocol SearchMoviesViewModelType {
    var inputs: SearchMoviesViewModelInputs { get }
    var outputs: SearchMoviesViewModelOutputs { get }
}

class SearchMoviesViewModel: SearchMoviesViewModelType, SearchMoviesViewModelInputs, SearchMoviesViewModelOutputs {
    
    //MARK: - Properties
    let disposeBag = DisposeBag()
    var isFavouriteMovieRemove: AnyObserver<Void>
    let storeDataManager: FavouriteMoviesDataManagerType
    let searchResultDataManager: SearchResultsDataManagerType
    let searchDataProvider: SearchDataProviderType
    var inputs: SearchMoviesViewModelInputs { return self }
    var outputs: SearchMoviesViewModelOutputs { return self }
    
    private let errorSubject = PublishSubject<String>()
    private let cancelSubject = PublishSubject<Void>()
    private let loadNextPageSubject = PublishSubject<Void>()
    private let searchInputTextSubject = PublishSubject<String?>()
    private let selectMovieSubject = PublishSubject<MovieResults>()
    private let moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    private let reloadDataSubject = PublishSubject<Void>()
    private let onTapSearchButtonSubject = PublishSubject<Void>()
    private let searchResultsSubject = PublishSubject<[String]?>()
    private let emptyStringSubject = PublishSubject<Void>()
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    
    //MARK: - Inputs
    var reloadDataObserver: AnyObserver<Void>{ reloadDataSubject.asObserver() }
    var selectMovieObserver: AnyObserver<MovieResults>{ selectMovieSubject.asObserver() }
    var cancelObserver: AnyObserver<Void>{ cancelSubject.asObserver() }
    var emptyStringObserver: AnyObserver<Void>{ emptyStringSubject.asObserver() }
    var searchInputTextObserver: AnyObserver<String?>{ searchInputTextSubject.asObserver() }
    var onTapSearchButtonObserver: AnyObserver<Void>{ onTapSearchButtonSubject.asObserver() }
    //MARK: - Outputs
    var error: Observable<String> { errorSubject.asObservable() }
    var cancel: Observable<Void>{ cancelSubject.asObservable() }
    var selectMovie: Observable<MovieResults>{ selectMovieSubject.asObservable() }
    var loadNextPageObserver: AnyObserver<Void>{ loadNextPageSubject.asObserver() }
    var reloadMovieData: Observable<Void>{ reloadDataSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { return dataSourceSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(searchDataProvider: SearchDataProviderType, storeDataManager: FavouriteMoviesDataManagerType, searchResultDataManager: SearchResultsDataManagerType, isFavouriteMovieRemove: AnyObserver<Void>) {
        self.isFavouriteMovieRemove = isFavouriteMovieRemove
        self.searchDataProvider = searchDataProvider
        self.storeDataManager = storeDataManager
        self.searchResultDataManager = searchResultDataManager
        makeCellViewModels()
        searchMoviesCoreSubjects()
        storeSearchResults()
        getSearchResults()
        initEmptyStringObserver()
    }
    
}

private extension SearchMoviesViewModel {
    func makeCellViewModels() {
        let cellViewModels = moviesSubject.unwrap().delay(.nanoseconds(100), scheduler: MainScheduler.instance)
            .map{ moviesList -> [ReusableTableViewCellViewModelType] in
                
                let viewModels = moviesList.map { [unowned self] movieList -> ReusableTableViewCellViewModelType in
                    let viewModel = MovieTableViewCellViewModel(movieResult: movieList)
                    
                    viewModel.outputs.favourite.subscribe(onNext:{[weak self] movie in
                        self?.storeDataManager.storeFavouriteMovie(movie: movie)
                        self?.reloadDataSubject.onNext(())
                    }).disposed(by: disposeBag)
                    
                    if let movies = storeDataManager.fetchFavouriteMovie() {
                        let isFavourite = movies.filter{ $0.id == viewModel.movieResult.id }.first.map{ _ in true  }
                        viewModel.inputs.isFavouriteIconObserver.onNext(isFavourite ?? false)
                    }
                    
                    return viewModel
                }
                return viewModels
            }
        
        let noResults = moviesSubject
            .delay(.nanoseconds(100), scheduler: MainScheduler.instance)
            .filter { $0?.count == 0 }
            .map{ moviesList -> [ReusableTableViewCellViewModelType] in
                let viewModels = moviesList.map { _ -> [ReusableTableViewCellViewModelType] in
                    return [NoSearchResultCellViewModel()]
                }
                return viewModels ?? []
            }
        
        let searchHistory = searchResultsSubject
            .delay(.nanoseconds(100), scheduler: MainScheduler.instance)
            .map{ results -> [ReusableTableViewCellViewModelType] in
                let viewModels = results.map { results -> [ReusableTableViewCellViewModelType] in
                    var viewModel = [ReusableTableViewCellViewModelType]()
                    for i in 0..<results.count {
                        viewModel.append(SearchHistoryTableViewCellViewModel(query: results[i], isHideHeading: i == 0 ? false : true))
                    }
                    return viewModel
                }
                return viewModels ?? []
            }
        
        Observable.merge(cellViewModels, noResults, searchHistory)
            .map { [SectionModel(model: 1, items: $0)]}
            .bind(to: dataSourceSubject)
            .disposed(by: disposeBag)
        
    }
    
    func searchMoviesCoreSubjects() {
        loadNextPageSubject.subscribe(onNext: {[unowned self] _ in
            guard !self.searchDataProvider.isLastPage() else { return }
            self.searchDataProvider.fetchSubject.onNext(())
        }).disposed(by: disposeBag)
        
        reloadMovieData.subscribe(onNext: {[unowned self] _ in
            self.searchDataProvider.refreshDataSourceSubject.onNext(())
            self.isFavouriteMovieRemove.onNext(())
        }).disposed(by: disposeBag)
        
        searchInputTextSubject
            .unwrap()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: searchDataProvider.searchMovieSubject)
            .disposed(by: disposeBag)
        
        searchDataProvider.result.bind(to: moviesSubject).disposed(by: disposeBag)
        
        searchDataProvider.error.bind(to: errorSubject).disposed(by: disposeBag)
    }
    
    func storeSearchResults() {
        onTapSearchButtonSubject.withLatestFrom(Observable.combineLatest(searchInputTextSubject, moviesSubject.unwrap()))
            .map{ return $0.1.count > 0 ? $0.0 : nil }
            .unwrap()
            .filter{ $0 != "" }
            .subscribe(onNext: {[weak self] inputString in
                self?.searchResultDataManager.storeSearchQuery(query: inputString)
            }).disposed(by: disposeBag)
    }
    
    func getSearchResults() {
        guard let searchResults = searchResultDataManager.fetchSearchResuls() else { return }
        searchResultsSubject.onNext(searchResults.reversed())
    }
    
    func initEmptyStringObserver() {
        emptyStringSubject.subscribe(onNext: {[weak self] _ in
            self?.searchDataProvider.resetDataSourceSubject.onNext(())
            self?.moviesSubject.onNext([])
            self?.getSearchResults()
        }).disposed(by: disposeBag)
    }
}
