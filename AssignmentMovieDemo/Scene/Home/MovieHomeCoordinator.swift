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
    let userDefaultsHelper: UserDefaultsHelper
    
    init(window: UIWindow, movieDataProvider: MovieDataProvider, userDefaultsHelper: UserDefaultsHelper) {
        self.window = window
        self.movieDataProvider = movieDataProvider
        self.userDefaultsHelper = userDefaultsHelper
    }
    
    override func start() -> Observable<ResultType<ResultType<Void>>> {
        
        let viewModel = MovieHomeViewModel(storeDataManager: FavouriteMoviesDataManager(storage: userDefaultsHelper), movieDataProvider: movieDataProvider )
        let viewController = MovieHomeViewController(viewModel: viewModel)
        root = UINavigationController(rootViewController: viewController)
        root.navigationBar.barStyle = UIBarStyle.black
        root.navigationBar.tintColor = UIColor.white
        window.rootViewController = root
        window.makeKeyAndVisible()
        
        viewModel.outputs.actionFavouriteMovies.subscribe(onNext: {[weak self] _ in
            self?.navigateToFavouriteMovies(isFavouriteMovieRemove: viewModel.inputs.isFavouriteMovieRemoveObserver)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.actionSearchMovies.subscribe(onNext: {[weak self] _ in
            self?.navigateToSearchMovies(isFavouriteMovieRemove: viewModel.inputs.isFavouriteMovieRemoveObserver)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.selectMovie.subscribe(onNext: {[weak self] movie in
            self?.navigateToMovieDetails(movie, reloadDataWhenFavouritDataUpdate: viewModel.inputs.isFavouriteMovieRemoveObserver )
        }).disposed(by: disposeBag)
        
        return result
    }
}

extension MovieHomeCoordinator {
    
    func navigateToFavouriteMovies(isFavouriteMovieRemove: AnyObserver<Void> ) {
        let viewModel = FavouriteMovieViewModel(storeDataManager: FavouriteMoviesDataManager(storage: userDefaultsHelper), isFavouriteMovieRemove: isFavouriteMovieRemove)
        let viewController = FavouriteMovieViewController(viewModel: viewModel)
        root.pushViewController(viewController, animated: true)
        
        viewModel.outputs.back.subscribe(onNext: {[weak self] _ in
            self?.root.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.selectMovie.subscribe(onNext: {[weak self] movie in
            self?.navigateToMovieDetails(movie, reloadDataWhenFavouritDataUpdate: viewModel.inputs.reloadDataObserver )
        }).disposed(by: disposeBag)
    }
    
    func navigateToSearchMovies(isFavouriteMovieRemove: AnyObserver<Void>) {
        let viewModel = SearchMoviesViewModel(searchDataProvider: SearchDataProvider(repository: MovieDemoRepository()), storeDataManager: FavouriteMoviesDataManager(storage: userDefaultsHelper), searchResultDataManager: SearchResultsDataManager(storage: userDefaultsHelper), isFavouriteMovieRemove: isFavouriteMovieRemove)
        let viewController = SearchMoviesViewController(viewModel: viewModel)
        root.pushViewController(viewController, animated: true)
        
        viewModel.outputs.cancel.subscribe(onNext: {[weak self] _ in
            self?.root.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.outputs.selectMovie.subscribe(onNext: {[weak self] movie in
            self?.navigateToMovieDetails(movie, reloadDataWhenFavouritDataUpdate: viewModel.inputs.reloadDataObserver )
        }).disposed(by: disposeBag)
    }
    
    func navigateToMovieDetails(_ movie: MovieResults, reloadDataWhenFavouritDataUpdate: AnyObserver<Void> ) {
        
        let viewModel = MovieDetailsViewModel(movie: movie, storeDataManager: FavouriteMoviesDataManager(storage: userDefaultsHelper), isFavouriteMovieRemove: reloadDataWhenFavouritDataUpdate)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        root.pushViewController(viewController, animated: true)
        
        viewModel.outputs.back.subscribe(onNext: {[weak self] _ in
            self?.root.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}
