//
//  MovieListInteractor.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import RxSwift

public protocol MovieListInteractorProtocol: AnyObject {
    func fetchMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovieModel>
}

public final class MovieListInteractor: MovieListInteractorProtocol{
    
    private let loader: MovieListLoader
    
    public init(loader: MovieListLoader) {
        self.loader = loader
    }
    
    public func fetchMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovieModel> {
        return loader.loadMovies(withGenres: withGenres, page: page)
    }
}
