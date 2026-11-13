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
        return client.get(from: requestedURL, apiKey: APIConfig.readAccessToken)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                
                switch response.statusCode {
                    case 200:
                        guard let root = try? JSONDecoder().decode(RootDTO.self, from: data) else {
                            return .error(NetworkError.decodeError)
                        }
                        return .just(root.genres.map { $0.toModel() })
                    case 401:
                        return .error(NetworkError.unauthorized)
                    case 404:
                        return .error(NetworkError.notFound)
                    default:
                        return .error(NetworkError.invalidData(statusCode: response.statusCode))
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
