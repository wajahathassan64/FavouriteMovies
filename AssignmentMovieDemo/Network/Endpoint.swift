//
//  Endpoint.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 10/04/2021.
//

import Foundation

enum URLRequestError: Error {
    case invalidURL
}
//https://api.themoviedb.org/3/movie/popular?api_key=93dcc3bae814845e8703d5b321b35f7a
public protocol URLRequestConvertible {
    func buildURLRequest() throws -> URLRequest
}

enum Route: String {
    case getMovieList = "/3/movie/popular"
    case searchMovie = "/3/search/movie"
}

enum HTTPMethod {
    case get
    case post(body: Data?)
    
    var toString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}

struct Endpoint {
    let scheme: String = "https"
    let host: String = "api.themoviedb.org"
    let route: Route
    let method: HTTPMethod
    let queryItems: [String: String]?
    let path: [String]?
    
    init(route: Route,
         method: HTTPMethod,
         path: [String]? = nil,
         queryItems: [String: String]? = nil) {
        self.route = route
        self.method = method
        self.path = path
        self.queryItems = queryItems
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = route.rawValue + (path?.compactMap { "/\($0)" }.joined() ?? "")
        components.queryItems = queryItems?.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }
}

extension Endpoint: URLRequestConvertible {
    func buildURLRequest() throws -> URLRequest {
        guard let url = url else { throw URLRequestError.invalidURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.toString
        
        if case let HTTPMethod.post(body) = method {
            request.httpBody = body
        }
        
        return request
    }
}
