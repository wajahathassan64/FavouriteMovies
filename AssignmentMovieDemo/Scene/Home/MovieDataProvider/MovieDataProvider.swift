//
//  MovieDataProvider.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

class MovieDataProvider: MovieDataProviderType {
    
    private var currentPage: Int
    private var totalPages: Int
    private var repository: MovieDemoRepository
    private var moviesListContainer: [MovieResults] = []
    private var moviesSubject: BehaviorSubject<[MovieResults]?>
    private var errorSubject: PublishSubject<String>
    var result: Observable<[MovieResults]?> { return moviesSubject.asObservable() }
    var error: Observable<String>{ errorSubject.asObservable() }
    let fetchSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    init(repository: MovieDemoRepository) {
        self.repository = repository
        moviesSubject = BehaviorSubject(value: nil)
        errorSubject = PublishSubject()
        currentPage = 0
        totalPages = 1
        fetchMovies()
    }
    
    func fetchMovies() {
        
        let request = fetchSubject.flatMap { [unowned self] in self.repository.getMovies(pageNumber: currentPage + 1) }.share()
        
        request.elements()
            .do(onNext: {[weak self] movies in self?.currentPage = movies?.page ?? 0; self?.totalPages = movies?.totalPages ?? 0 })
            .unwrap()
            .map{[weak self] movies -> [MovieResults]? in
                self?.moviesListContainer
                    .append(contentsOf: movies.movieList)
                return self?.moviesListContainer
            }.bind(to: moviesSubject).disposed(by: disposeBag)
        
        request.errors().map{ $0.localizedDescription }.bind(to: errorSubject).disposed(by: disposeBag)
    }
    
    func isLastPage() -> Bool {
        return currentPage == totalPages
    }
    
}
