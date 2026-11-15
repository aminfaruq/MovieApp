//
//  MovieReviewModel.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import Foundation

public struct PaginatedResponseMovieReviewModel: Equatable {
    public let id: Int
    public let page: Int
    public let totalPages: Int
    public let totalResults: Int
    public let results: [MovieReviewModel]
    
    public init(
        id: Int,
        page: Int,
        totalPages: Int,
        totalResults: Int,
        results: [MovieReviewModel]
    ) {
        self.id = id
        self.page = page
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.results = results
    }
}

public struct MovieReviewModel: Equatable {
    public let id: String
    public let userName: String
    public let rating: String
    public let content: String
    
    public init(
        id: String,
        userName: String,
        rating: String,
        content: String
    ) {
        self.id = id
        self.userName = userName
        self.rating = rating
        self.content = content
    }
}

