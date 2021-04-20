//
//  SearchDataProvider.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//
import RxSwift

class SearchDataProvider: SearchDataProviderType {
    
    //MARK: - Properties
    internal var totalPages: Int
    internal var currentPage: Int
    internal let disposeBag = DisposeBag()
    internal var repository: MovieDemoRepository
    internal var errorSubject = PublishSubject<String>()
    internal var moviesListContainer: [MovieResults] = []
    internal var moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    
    var searchQuery: String
    let fetchSubject = PublishSubject<Void>()
    var resetDataSourceSubject = PublishSubject<Void>()
    var refreshDataSourceSubject = PublishSubject<Void>()
    var error: Observable<String>{ errorSubject.asObservable() }
    var searchMovieSubject = BehaviorSubject<String?>(value: nil)
    var result: Observable<[MovieResults]?> { return moviesSubject.asObservable() }
    
    //MARK: - Constructor
    init(repository: MovieDemoRepository) {
        self.repository = repository
        searchQuery = ""
        currentPage = 0
        totalPages = 1
        searchMovies()
        resetDataSource()
        refreshDataSource()
    }
    
    private func searchMovies() {
        
        let request =  Observable.combineLatest(fetchSubject, searchMovieSubject)
            .map{ $0.1 }
            .unwrap()
            .filter{ !$0.isEmpty }
            .do(onNext:{[weak self] in
                if $0 != self?.searchQuery {
                    self?.moviesListContainer = []
                    self?.searchQuery = $0
                    self?.currentPage = 0
                }
            })
            .flatMap { [unowned self] in self.repository.searchMovies(searchText: $0, pageNumber: currentPage + 1) }
            .share()
        
        request.elements()
            .do(onNext: {[weak self] movies in self?.currentPage = movies?.page ?? 0; self?.totalPages = movies?.totalPages ?? 0 })
            .unwrap()
            .map{[weak self] movies -> [MovieResults]? in
                self?.moviesListContainer
                    .append(contentsOf: movies.movieList)
                return self?.moviesListContainer
            }
            .bind(to: moviesSubject).disposed(by: disposeBag)
        
        request.errors().map{ $0.localizedDescription }.bind(to: errorSubject).disposed(by: disposeBag)
        
    }
    
    private func resetDataSource() {
        resetDataSourceSubject.subscribe(onNext: {[unowned self] _ in
            self.moviesListContainer = []
            self.currentPage = 0
        }).disposed(by: disposeBag)
    }
    
    private func refreshDataSource() {
        refreshDataSourceSubject.subscribe(onNext: {[unowned self] _ in
            self.moviesSubject.onNext(self.moviesListContainer)
        }).disposed(by: disposeBag)
    }
    
    func isLastPage() -> Bool {
        return currentPage == totalPages
    }
}
