//
//  AppCoordinator.swift
//  AssignmentMovieDemo
//
//  Created by Wajahat Hassan on 11/04/2021.
//

import Foundation

import UIKit
import RxSwift

class AppCoordinator: Coordinator<ResultType<Void>> {

    private let window: UIWindow
    
    private lazy var movieDemoRepository: MovieDemoRepository = {
        MovieDemoRepository()
    }()
        
    
    init(window: UIWindow, shortcutItem: UIApplicationShortcutItem?) {
        self.window = window
        super.init()
    }

    override func start() -> Observable<ResultType<Void>> {
        MovieHomeCoordinator()
        return Observable.never()
    }

}

//MARK: Navigation
private extension AppCoordinator {
    
    func MovieHomeCoordinator() {
        self.coordinate(to: AssignmentMovieDemo.MovieHomeCoordinator(window: self.window, movieDataProvider: MovieDataProvider(repository: MovieDemoRepository()), userDefaultsHelper: UserDefaultsHelper()))
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    
}
