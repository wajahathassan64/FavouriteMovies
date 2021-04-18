//
//  ServicesInitializer.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation

public class ServiceInstance {
    lazy var movieService: MovieService = {
        return MovieService()
    }()
}
