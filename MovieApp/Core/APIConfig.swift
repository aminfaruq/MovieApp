//
//  APIConfig.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

import Foundation

public enum APIConfig {
    public static let baseURL = URL(string: "https://api.themoviedb.org/3")!
    // TMDB API Read Access Token (v4)
    public static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    public static let readAccessToken = "YOUR_TMDB_V4_READ_ACCESS_TOKEN"
}
