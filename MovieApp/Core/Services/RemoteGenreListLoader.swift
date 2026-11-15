//
//  RemoteGenreListLoader.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

import RxSwift
import Foundation

public protocol GenreListLoader {
    func loadGenres() -> Single<[GenreModel]>
}

public final class RemoteGenreListLoader: GenreListLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadGenres() -> Single<[GenreModel]> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "genre")
            .appending(path: "movie")
            .appending(path: "list")
            .appending(queryItems: [
                URLQueryItem(name: "language", value: "en-US")
            ])
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                mapResponse(data: data, response: response) { (root: RootDTO) in
                    root.genres.map { $0.toModel() }
                }
            }
    }
    
    private struct RootDTO: Decodable {
        let genres: [RemoteGenreDTO]
    }
    
    private struct RemoteGenreDTO: Decodable {
        private let id: Int
        private let name: String
        
        func toModel() -> GenreModel {
            .init(id: id, name: name)
        }
    }
}
