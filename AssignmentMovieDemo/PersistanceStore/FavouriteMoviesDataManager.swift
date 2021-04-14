//
//  FavouriteMoviesDataManager.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation
import RxSwift

protocol FavouriteMoviesDataManagerType: class {
    func storeFavouriteMovie(movie: MovieResults)
    func fetchFavouriteMovie() -> [MovieResults]?
    var successSubject: PublishSubject<Void>{ get }
}

class FavouriteMoviesDataManager: FavouriteMoviesDataManagerType {
    
    //MARK: - Properties
    var successSubject: PublishSubject<Void> = PublishSubject<Void>()
    let storage: PersistentStoreHelperType
    
    init(storage: PersistentStoreHelperType) {
        self.storage = storage
    }
    
    func storeFavouriteMovie(movie: MovieResults) {
        var loadFavouriteMovie: [MovieResults] = []
        
        if var data = fetchFavouriteMovie(), data.count > 0 {
            if let index = data.firstIndex(of: movie) {
                data.remove(at: index)
                removeFavouriteMovie()
                loadFavouriteMovie = data
                save(data: loadFavouriteMovie)
                return
            }
            loadFavouriteMovie = data
            loadFavouriteMovie.append(movie)
        }else{
            loadFavouriteMovie.append(movie)
        }
        save(data: loadFavouriteMovie)
    }
    
    private func save(data: [MovieResults]) {
        if let encode = try? JSONParser.encode(value: data) {
            self.storage.setData(value: encode, key: Keys.favouriteMovie.localize)
            successSubject.onNext(())
        }
    }
    
    func fetchFavouriteMovie() -> [MovieResults]? {
        if let data = self.storage.getData(type: Data.self, forkey:  Keys.favouriteMovie.localize) {
            if let loadedData = try? JSONParser.decode(value: data) as [MovieResults] {
                return loadedData
            }
        }
        return nil
    }
    
    private func removeFavouriteMovie() {
        storage.removeData(key: Keys.favouriteMovie.localize)
    }
}
