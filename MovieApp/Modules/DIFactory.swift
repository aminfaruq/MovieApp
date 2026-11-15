//
//  DIFactory.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

final class DIFactory {
    
    private static func createClient() -> HTTPClient {
        return URLSessionHTTPClient()
    }
    
    static func createGenreListLoader() -> GenreListLoader {
        return RemoteGenreListLoader(client: createClient())
    }
    
    static func createMovieListLoader() -> MovieListLoader {
        return RemoteMovieListLoader(client: createClient())
    }
}
