//
//  MovieResults.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//
import UIKit

struct MovieResults: Codable, Equatable {
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let title: String
    let posterPath: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
    }
    
    private var posterImageUrl: String? {
        guard let path = posterPath else { return nil}
        return "https://image.tmdb.org/t/p/w92" + path /*92, 154, 185, 342, 500, 780*/
    }
    
    var posterImageWithUrl: ImageWithURL {
        return (posterImageUrl, title.initialsImage(color: UIColor.randomColor()))
    }
    
    private var bannerImageUrl: String? {
        guard let path = backdropPath else { return nil}
        return "https://image.tmdb.org/t/p/w500" + path /*92, 154, 185, 342, 500, 780*/
    }
    
    var bannerImageWithUrl: ImageWithURL {
        return (bannerImageUrl, title.initialsImage(color: UIColor.randomColor()))
    }
    
    var formattedReleaseDate: String {
        let dateFormatter = DateFormatter()
        guard let date = dateFormatter.date(from: releaseDate ?? "") else { return "" }
        return date.localizedStringOfDate
    }
}
