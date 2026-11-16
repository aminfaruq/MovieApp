//
//  MovieDetailProtocols.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//

import Foundation

public protocol MovieDetailViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(movie: MovieDetailModel)
    func display(trailerURL: URL?)
    func display(reviews: [MovieReviewModel])
    func display(isPaginationLoading: Bool)
    func display(showErrorMessage: String)
}

public protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    
    func viewDidLoad()
    func didLoadMore()
}
