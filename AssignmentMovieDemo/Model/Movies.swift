//
//  Movies.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

struct Movies: Codable {
    
    let page: Int
    let movieList: [MovieResults]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movieList = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
}
