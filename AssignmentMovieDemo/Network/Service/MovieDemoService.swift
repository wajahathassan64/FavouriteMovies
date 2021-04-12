//
//  Service.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

class MovieDemoService  {
    
    private let apiClient: WebClient
    private let apiKey : String
    
    public init() {
        self.apiClient = WebClient()
        self.apiKey = "93dcc3bae814845e8703d5b321b35f7a"
    }
    
    public func getMovies<T: Codable>(pageNumber: Int) -> Observable<T> {
        let endPoint = Endpoint(route: .getMovieList, method: .get, path: nil, queryItems: ["api_key" : apiKey, "page" : "\(pageNumber)"])
        return apiClient.send(requestConvertiable: endPoint)
        
    }
}
