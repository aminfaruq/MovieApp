//
//  MovieListProtocols.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import UIKit

public protocol MovieListViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(movies: [MovieModel])
    func display(showErrorMessage: String)
    func display(isPaginationLoading: Bool)
}

public protocol MovieListRouterProtocol: AnyObject {
    
    static func createModule(genre: GenreModel) -> UIViewController
    
    func navigateToDetail(view: MovieListViewProtocol?, id: Int)
}

public protocol MovieListPresenterProtocol: AnyObject {
    var view: MovieListViewProtocol? { get set }
    var interactor: MovieListInteractorProtocol? { get set }
    var router: MovieListRouterProtocol? { get set }
    
    func viewDidLoad()
    func didLoadMore()
    func didPullToRefresh()
    func didSelectMovie(id: Int)
}
