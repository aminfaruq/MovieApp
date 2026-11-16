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
    
    public var errorDescription: String? {
        switch self {
            case .connectivity:
                "failed to connect, please check your connection"
            case .decodeError:
                "failed to decode from server"
            case .unauthorized:
                "expired"
            case .notFound:
                "not found"
            case .invalidData(let statusCode):
                "invalid data with \(statusCode)"
        }
    }
}
