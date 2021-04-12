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
    private let disposeBag = DisposeBag()
    let fetchSubject = PublishSubject<Void>()
    private var moviesListContainer: [MovieResults] = []
    private var moviesSubject: BehaviorSubject<[MovieResults]?>
    var movies: Observable<[MovieResults]?> { return moviesSubject.asObservable() }
    
    
    init(repository: MovieDemoRepository) {
        self.repository = repository
        self.moviesSubject = BehaviorSubject(value: nil)
        self.currentPage = 0
        self.totalPages = 1
        fetchMovies()
    }
    
    func fetchMovies() {
        let request = fetchSubject
            .flatMap { [unowned self] in
                self.repository.getMovies(pageNumber: currentPage + 1)
            }
            .share()
        
        request.elements()
            .debug(".elements()")
            .do(onNext: {[weak self] movies in
                self?.currentPage = movies?.page ?? 0;
                self?.totalPages = movies?.totalPages ?? 0
            })
            .unwrap()
            .map{ movies -> [MovieResults]? in self.moviesListContainer.append(contentsOf: movies.movieList)
                return self.moviesListContainer
            }.bind(to: moviesSubject).disposed(by: disposeBag)
    }
    
    func isLastPage() -> Bool {
        return currentPage == totalPages
    }
    
    
}
