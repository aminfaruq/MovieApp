//
//  NetworkError.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

import Foundation

public enum NetworkError: Swift.Error, Equatable, LocalizedError {
    case connectivity
    case decodeError
    case unauthorized
    case notFound
    case invalidData(statusCode: Int)
}
