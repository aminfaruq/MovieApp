//
//  GenreListRouter.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import UIKit

final class GenreListRouter: GenreListRouterProtocol {
    
    static func createModule() -> UIViewController {
        let view = GenreListViewController()
        let presenter = GenreListPresenter()
        let interactor = GenreListInteractor(loader: DIFactory.createGenreListLoader())
        let router = GenreListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
    
    func navigateToMovieList(view: (any GenreListViewProtocol)?, id: Int) {
        
    }
    
}
