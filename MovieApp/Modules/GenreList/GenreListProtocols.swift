//
//  GenreListProtocols.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//
import UIKit

public protocol GenreListViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(genres: [GenreModel])
    func display(showErrorMessage: String)
}

public protocol GenreListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    
    func navigateToMovieList(view: GenreListViewProtocol?, id: Int)
}

public protocol GenreListPresenterProtocol: AnyObject {
    var view: GenreListViewProtocol? { get set }
    var interactor: GenreListInteractorProtocol? { get set }
    var router: GenreListRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectGenre(id: Int)
}
