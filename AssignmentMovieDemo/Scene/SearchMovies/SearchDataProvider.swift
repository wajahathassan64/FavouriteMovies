//
//  SearchDataProvider.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 15/04/2021.
//
import RxSwift

class SearchDataProvider: SearchDataProviderType {
    //MARK: - Properties
    private var repository: MovieDemoRepository
    private let disposeBag = DisposeBag()
    private var currentPage: Int
    private var totalPages: Int
    private var errorSubject = PublishSubject<String>()
    private var moviesListContainer: [MovieResults] = []
    private var moviesSubject = BehaviorSubject<[MovieResults]?>(value: nil)
    var error: Observable<String>{ errorSubject.asObservable() }
    var result: Observable<[MovieResults]?> { return moviesSubject.asObservable() }
    let fetchSubject = PublishSubject<Void>()
    var searchMovieSubject = BehaviorSubject<String?>(value: nil)
    var searchQuery = ""
    var reloadDataSubject = PublishSubject<Void>()
    
    init(repository: MovieDemoRepository) {
        self.repository = repository
        currentPage = 0
        totalPages = 1
        searchMovies()
    }
    
    func searchMovies() {
        
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
        
        reloadDataSubject.subscribe(onNext: {[weak self] _ in
            self?.moviesSubject.onNext(self?.moviesListContainer)
        }).disposed(by: disposeBag)
    }
    
    func isLastPage() -> Bool {
        return currentPage == totalPages
    }
}
