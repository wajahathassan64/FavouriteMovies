//
//  SearchResultsDataManager.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 18/04/2021.
//

import Foundation
import RxSwift

protocol SearchResultsDataManagerType: CommonProtocolType {
    func storeSearchQuery(query: String)
    func fetchSearchResuls() -> [String]?
}

class SearchResultsDataManager: SearchResultsDataManagerType {
    
    //MARK: - Properties
    private let searchResultsCapacity = 10
    private let storage: PersistentStoreHelperType
    let successSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    init(storage: PersistentStoreHelperType) {
        self.storage = storage
    }
    
    func storeSearchQuery(query: String) {
        if var data = fetchSearchResuls(), data.count > 0 {
            if data.contains(query) == false {
                if data.count == searchResultsCapacity {
                    data.removeFirst()
                    resetSearchResults()
                    data.append(query)
                    save(data: data)
                    
                }else{ data.append(query); save(data: data) }
            }
        }else { save(data: [query]) }
    }
    
    
    private func save(data: [String]) {
        guard let encode = try? JSONParser.encode(value: data) else { return }
        self.storage.setData(value: encode, key: Keys.searchResult.localize)
    }
    
    func fetchSearchResuls() -> [String]? {
        guard let data = self.storage.getData(type: Data.self, forkey:  Keys.searchResult.localize) else { return nil }
        guard let storedData = try? JSONParser.decode(value: data) as [String] else { return nil }
        return storedData
    }
    
    private func resetSearchResults() {
        storage.removeData(key: Keys.searchResult.localize)
    }
}
