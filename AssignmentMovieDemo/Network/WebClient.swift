//
//  WebClient.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 10/04/2021.
//

import Foundation
import RxSwift
import RxSwiftExt

public class WebClient {
    public func send<T: Decodable>(requestConvertiable: URLRequestConvertible) -> Observable<T> {
        return Observable.create { observer in
            do {
                let urlRequest = try requestConvertiable.buildURLRequest()
                print("Initiating request: \(urlRequest.url!)")
                let task = URLSession.shared.dataTask(with: urlRequest) {
                    data, response, error in
                    error.map { observer.onError($0) }
                    do {
//                                                data.map { String(data: $0, encoding: .utf8 ).map { print("Response for : \(urlRequest.url?.absoluteString ?? "")" + "\n" + $0) } }
                        try data.map { validData in
                            let decodedObject: T = try JSONParser.decode(value: validData)
                            observer.onNext(decodedObject)
                        }
                    } catch {
                        observer.onError(error)
                    }
                }
                
                task.resume()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
