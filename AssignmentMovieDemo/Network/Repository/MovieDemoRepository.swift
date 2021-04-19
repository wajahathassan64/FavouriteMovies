//
//  Repository.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

protocol MovieDemoRepositoryType {
    func getMovies(pageNumber: Int) -> Observable<Event<Movies?>>
    func searchMovies(searchText: String, pageNumber: Int) -> Observable<Event<Movies?>>
}

class MovieDemoRepository: Microservices, MovieDemoRepositoryType {
    
    func getMovies(pageNumber: Int) -> Observable<Event<Movies?>> {
        return movieService.getMovies(pageNumber: pageNumber).materialize()
    }
    
    func searchMovies(searchText: String, pageNumber: Int)  -> Observable<Event<Movies?>> {
        return movieService.searchMovie(searchText: searchText, pageNumber: pageNumber).materialize()
    }
    
}
