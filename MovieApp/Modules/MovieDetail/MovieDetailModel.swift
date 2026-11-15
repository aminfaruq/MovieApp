//
//  MovieDetailModel.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import Foundation

public struct MovieDetailModel: Equatable {
    public let id: Int
    public let title: String
    public let tagline: String
    public let overview: String
    public let releaseData: String
    public let runtime: String
    public let voteAverage: String
    public let genres: [GenreModel]
    public let posterPath: URL
    public let backdropPath: URL
    
    public init(
        id: Int,
        title: String,
        tagline: String,
        overview: String,
        releaseData: String,
        runtime: String,
        voteAverage: String,
        genres: [GenreModel],
        posterPath: URL,
        backdropPath: URL
    ) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.overview = overview
        self.releaseData = releaseData
        self.runtime = runtime
        self.voteAverage = voteAverage
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
    }
}
