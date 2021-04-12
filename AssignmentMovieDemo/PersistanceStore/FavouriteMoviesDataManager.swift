//
//  FavouriteMoviesDataManager.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 13/04/2021.
//

import Foundation

class FavouriteMoviesDataManager {
    
    //MARK: - Properties
    let storage: PersistentStoreHelperType
    
    init(storage: PersistentStoreHelperType) {
        self.storage = storage
    }
    
    func storeFavouriteMovie(movie: MovieResults) {
        var loadFavouriteMovie: [MovieResults] = []
        if let data = fetchFavouriteMovie() {
            loadFavouriteMovie = data
            loadFavouriteMovie.append(movie)
        }else{
            loadFavouriteMovie.append(movie)
        }
        if let encode = try? JSONParser.encode(value: loadFavouriteMovie) {
            self.storage.setData(value: encode, key: Keys.favouriteMovie.localize)
        }
    }
    
    func fetchFavouriteMovie() -> [MovieResults]? {
        //
        //        if let savedPerson = UserDefaults.standard.object(forKey: "SavedPerson") as? Data {
        //            let decoder = JSONDecoder()
        //            if let loadedPerson = try? decoder.decode([MovieResults].self, from: savedPerson) {
        //                print(loadedPerson.first?.title)
        //            }
        //        }
        
        if let data = self.storage.getData(type: Data.self, forkey:  Keys.favouriteMovie.localize) {
            if let loadedData = try? JSONParser.decode(value: data) as [MovieResults] {
                return loadedData
            }
        }
        return nil
    }
    
}
