//
//  UserDefaultsHelper.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation

protocol PersistentStoreHelperType {
    func setData<T: Codable>(value: T, key: String)
    func getData<T: Codable>(type: T.Type, forkey: String) -> T?
    func removeData(key: String)
}

final class UserDefaultsHelper: PersistentStoreHelperType {
    
    func setData<T: Codable>(value: T, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func getData<T: Codable>(type: T.Type, forkey: String) -> T? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: forkey) as? T
    }
    
    func removeData(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
}
