//
//  MoviewHomeCoordtinator.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation
import RxSwift

class MovieHomeCoordinator: Coordinator<ResultType<ResultType<Void>>> {
    
    private let window: UIWindow
    var root: UINavigationController!
    let movieDataProvider: MovieDataProvider
    let result = PublishSubject<ResultType<ResultType<Void>>>()
    
    init(window: UIWindow, movieDataProvider: MovieDataProvider) {
        self.window = window
        self.movieDataProvider = movieDataProvider
    }
    
    override func start() -> Observable<ResultType<ResultType<Void>>> {
        
        let viewModel : MovieHomeViewModelType = MovieHomeViewModel(storeDataManager: FavouriteMoviesDataManager(storage: UserDefaultsHelper()), movieDataProvider: self.movieDataProvider )
        let viewController = MovieHomeViewController(viewModel: viewModel)
        root = UINavigationController(rootViewController: viewController)
        root.navigationBar.tintColor = .white
        root.navigationBar.barTintColor = .black
        window.rootViewController = root
        window.makeKeyAndVisible()
        return result
    }
}
