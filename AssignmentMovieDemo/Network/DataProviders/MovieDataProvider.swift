//
//  MovieDataProvider.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

class MovieDataProvider: SearchDataProvider, MovieDataProviderType {
    
    //MARK: - Constructor
    override init(repository: MovieDemoRepository) {
        super.init(repository: repository)
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
    
}
