//
//  RemoteMovieDetailLoader.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import Foundation
import RxSwift

public final class RemoteMovieDetailLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadMovie(id: Int) -> Single<MovieDetailModel> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "movie")
            .appending(path: "\(id)")
            .appending(queryItems: [
                URLQueryItem(name: "language", value: "en-US")
            ])
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                mapResponse(data: data, response: response) { (root: RootMovieDTO) in
                    root.toModel()
                }
            }
    }
    
    public func loadReviews(id: Int, page: Int) -> Single<PaginatedResponseMovieReviewModel> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "movie")
            .appending(path: "\(id)")
            .appending(path: "reviews")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)")
            ])
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                mapResponse(data: data, response: response) { (root: RootReviewDTO) in
                    root.toModel()
                }
            }
    }
    
    public func loadTrailers(id: Int) -> Single<[TrailerModel]> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "movie")
            .appending(path: "\(id)")
            .appending(path: "videos")
            .appending(queryItems: [
                URLQueryItem(name: "language", value: "en-US")
            ])
        
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                mapResponse(data: data, response: response) { (root: RootTrailerDTO) in
                    root.results.map { $0.toModel() }
                }
            }
    }
}

extension RemoteMovieDetailLoader {
    private struct RootMovieDTO: Decodable {
        private let id: Int
        private let title: String
        private let tagline: String
        private let overview: String
        private let release_date: String
        private let runtime: Int
        private let vote_average: Double
        private let genres: [RemoteGenreDTO]
        private let poster_path: String
        private let backdrop_path: String
        
        func toModel() -> MovieDetailModel {
            .init(
                id: id,
                title: title,
                tagline: tagline,
                overview: overview,
                releaseDate: "\(release_date)",
                runtime: "\(runtime)",
                voteAverage: "\(vote_average)",
                genres: genres.map { $0.toModel() },
                posterPath: URL(string: APIConfig.imageBaseURL + poster_path) ?? URL(string: "about:blank")!,
                backdropPath: URL(string: APIConfig.imageBaseURL + backdrop_path) ?? URL(string: "about:blank")!
            )
        }
    }
    
    private struct RemoteGenreDTO: Decodable {
        private let id: Int
        private let name: String
        
        func toModel() -> GenreModel {
            .init(id: id, name: name)
        }
    }
    
    private struct RootReviewDTO: Decodable {
        private let id: Int
        private let page: Int
        private let total_pages: Int
        private let total_results: Int
        private let results: [RemoteReviewDTO]
        
        func toModel() -> PaginatedResponseMovieReviewModel {
            .init(
                id: id,
                page: page,
                totalPages: total_pages,
                totalResults: total_results,
                results: results.map { $0.toModel() }
            )
        }
    }
    
    private struct RemoteReviewDTO: Decodable {
        private let id: String
        private let content: String
        private let author_details: RemoteAuthorDetailDTO
        
        func toModel() -> MovieReviewModel {
            .init(
                id: id,
                username: author_details.username,
                rating: "\(author_details.rating ?? 0)",
                content: content
            )
        }
    }
    
    private struct RemoteAuthorDetailDTO: Decodable {
        let username: String
        let rating: Int?
    }
    
    private struct RootTrailerDTO: Decodable {
        let results: [RemoteTrailerDTO]
    }
    
    private struct RemoteTrailerDTO: Decodable {
        private let id: String
        private let name: String
        private let key: String
        private let site: String
        private let size: Int
        private let type: String
        private let official: Bool
        
        func toModel() -> TrailerModel {
            .init(
                id: id,
                name: name,
                key: key,
                site: site,
                size: size,
                type: type,
                official: official
            )
        }
    }
}
