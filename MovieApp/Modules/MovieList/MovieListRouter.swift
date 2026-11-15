//
//  MovieListRouter.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

final class MovieListRouter: MovieListRouterProtocol {
    
    static func createModule(genre: GenreModel) -> UIViewController {
        let view = MovieListViewController()
        let interactor = MovieListInteractor(loader: DIFactory.createMovieListLoader())
        let presenter = MovieListPresenter(genreId: genre.id)
        let router = MovieListRouter()
        view.title = genre.name
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        return view
    }
    
    func navigateToDetail(view: (any MovieListViewProtocol)?, id: Int) {
        
    }
    
}
