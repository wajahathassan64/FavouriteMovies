////
////  MovieTableViewCellViewModel.swift
////  AssignmentMovieDemo
////
////  Created by Wajahat Hassan on 13/04/2021.
////
//
import Foundation
import RxSwift

protocol MovieTableViewCellViewModelInputs {
    var favouriteIconTapObserver: AnyObserver<Void>{ get }
    var isFavouriteIconObserver: AnyObserver<Bool>{ get }
}

protocol MovieTableViewCellViewModelOutputs {
    var posterUrl: Observable<ImageWithURL?>{ get }
    var name: Observable<String>{ get }
    var releaseDate: Observable<String>{ get }
    var favourite: Observable<MovieResults>{ get }
    var isFavouriteIcon: Observable<Bool>{ get }
}

protocol MovieTableViewCellViewModelType {
    var inputs: MovieTableViewCellViewModelInputs { get }
    var outputs: MovieTableViewCellViewModelOutputs { get }
}

class MovieTableViewCellViewModel: ReusableTableViewCellViewModelType, MovieTableViewCellViewModelType, MovieTableViewCellViewModelInputs, MovieTableViewCellViewModelOutputs {
    
    var inputs: MovieTableViewCellViewModelInputs { return self }
    var outputs: MovieTableViewCellViewModelOutputs { return self }
    
    //MARK: - Properties
    let movieResult: MovieResults
    let disposeBag = DisposeBag()
    var reusableIdentifier: String { return MovieTableViewCell.reuseIdentifier }
    
    //MARK: - Subjects
    private var posterUrlSubject = BehaviorSubject<ImageWithURL?>(value: nil)
    private var nameSubject = BehaviorSubject<String>(value: "")
    private var releaseDateSubject = BehaviorSubject<String>(value: "")
    private let favouriteIonTapSubject = PublishSubject<Void>()
    private let removeFavouriteSubject = PublishSubject<MovieResults>()
    private let isFavouriteIconSubject = BehaviorSubject<Bool>(value: false)
    
    //MARK: - Inputs
    var favouriteIconTapObserver: AnyObserver<Void>{ favouriteIonTapSubject.asObserver() }
    var isFavouriteIconObserver: AnyObserver<Bool>{ isFavouriteIconSubject.asObserver() }
    
    //MARK: - Outputs
    var posterUrl: Observable<ImageWithURL?>{ posterUrlSubject.asObservable() }
    var name: Observable<String>{ nameSubject.asObservable() }
    var releaseDate: Observable<String>{ releaseDateSubject.asObservable() }
    var favourite: Observable<MovieResults>{ removeFavouriteSubject.asObservable() }
    var isFavouriteIcon: Observable<Bool>{ isFavouriteIconSubject.asObservable() }
    
    //MARK: - Constructor/init
    init(movieResult: MovieResults) {
        
        self.movieResult = movieResult
        posterUrlSubject = BehaviorSubject(value: self.posterImageWithUrl)
        nameSubject = BehaviorSubject(value: movieResult.title)
        releaseDateSubject = BehaviorSubject(value: movieResult.releaseDate ?? "")
        favouriteIonTapSubject.map{ self.movieResult }.bind(to: removeFavouriteSubject).disposed(by: disposeBag)
        
    }
    
}

extension MovieTableViewCellViewModel {
    var posterImageUrl: String? {
        guard let path = movieResult.posterPath else { return nil}
        return "https://image.tmdb.org/t/p/w342" + path
    }
    
    var posterImageWithUrl: ImageWithURL {
        return (posterImageUrl, nil)
    }
}
