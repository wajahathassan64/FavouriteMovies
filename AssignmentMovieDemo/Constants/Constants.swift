//
//  Constants.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 12/04/2021.
//


enum Keys {
    case favouriteMovie
}

extension Keys {
    var localize: String {
        switch self {
        case .favouriteMovie:
            return "FAVOURITE_MOVIE"
        }
    }
}
