//
//  MovieDetailInteractor.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import RxSwift

public protocol MovieDetailInteractorProtocol: AnyObject {
    func fetchMovie(id: Int) -> Single<MovieDetailModel>
    func fetchReviews(id: Int, page: Int) -> Single<PaginatedResponseMovieReviewModel>
    func fetchTrailers(id: Int) -> Single<[TrailerModel]>
}

public final class MovieDetailInteractor: MovieDetailInteractorProtocol {
    
    private let loader: MovieDetailLoader
    
    public init(loader: MovieDetailLoader) {
        self.loader = loader
    }
    
    public func fetchMovie(id: Int) -> Single<MovieDetailModel> {
        return loader.loadMovie(id: id)
    }
    
    public func fetchReviews(id: Int, page: Int) -> Single<PaginatedResponseMovieReviewModel> {
        return loader.loadReviews(id: id, page: page)
    }
    
    public func fetchTrailers(id: Int) -> Single<[TrailerModel]> {
        return loader.loadTrailers(id: id)
    }
}
