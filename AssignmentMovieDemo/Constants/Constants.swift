//
//  Constants.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 12/04/2021.
//


enum Keys {
    case favouriteMovie
    case searchResult
}

extension Keys {
    var localize: String {
        switch self {
        case .favouriteMovie:
            return "FAVOURITE_MOVIE"
        case .searchResult:
            return "SEARCH_RESULT"
        }
    }
}
