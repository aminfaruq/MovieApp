//
//  MovieModel.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//
import Foundation

public struct PaginatedResponseMovieModel: Equatable {
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    public let results: [MovieModel]
    
    public init(page: Int, totalPages: Int, totalResults: Int, results: [MovieModel]) {
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.results = results
    }
}

public struct MovieModel: Equatable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: URL
    public let releaseDate: String
    public let voteAverage: String
    
    public init(id: Int, title: String, overview: String, posterPath: URL, releaseDate: String, voteAverage: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}
