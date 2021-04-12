//
//  JSONParser.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 10/04/2021.
//

import Foundation

public class JSONParser {
    public class func encode<T: Encodable>(value: T) throws -> Data? {
        let jsonEncoder = JSONEncoder()
        return try jsonEncoder.encode(value)
    }
    
    public class func decode<T: Decodable>(value: Data) throws -> T {
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(T.self, from: value)
    }
}
