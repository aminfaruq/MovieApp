//
//  RemoteMovieListLoader.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//
import Foundation
import RxSwift

public protocol MovieListLoader {
    func loadMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovieModel>
}

public final class RemoteMovieListLoader: MovieListLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovieModel> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "discover")
            .appending(path: "movie")
            .appending(queryItems: [
                URLQueryItem(name: "with_genres", value: "\(withGenres)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: "popularity.desc")
            ])
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                mapResponse(data: data, response: response) { (root: RootDTO) in
                    root.toModel()
                }
            }
    }
    
    private struct RootDTO: Decodable {
        private let page: Int
        private let results: [RemoteMovieDTO]
        private let total_pages: Int
        private let total_results: Int
        
        func toModel() -> PaginatedResponseMovieModel {
            .init(
                page: page,
                totalPages: total_pages,
                totalResults: total_results,
                results: results.map { $0.toModel() }
            )
        }
    }
    
    private struct RemoteMovieDTO: Decodable {
        private let id: Int
        private let title: String
        private let overview: String
        private let poster_path: String
        private let release_date: String
        private let vote_average: Double
        
        func toModel() -> MovieModel {
            .init(
                id: id,
                title: title,
                overview: overview,
                posterPath: URL(string: APIConfig.imageBaseURL + poster_path) ?? URL(string: "about:blank")!,
                releaseDate: release_date,
                voteAverage: "\(vote_average)"
            )
        }
    }
}
