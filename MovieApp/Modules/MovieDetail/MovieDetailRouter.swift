//
//  MovieDetailRouter.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

final class MovieDetailRouter {
    
    static func createModule(id: Int) -> UIViewController {
        let view = MovieDetailViewController()
        let presenter = MovieDetailPresenter(id: id)
        let interactor = MovieDetailInteractor(loader: DIFactory.createMovieDetailLoader())
        view.title = "Movie Detail"
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        
        return view
    }
}
