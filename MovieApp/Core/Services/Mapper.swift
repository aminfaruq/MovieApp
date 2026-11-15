//
//  Mapper.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import RxSwift
import Foundation

public func mapResponse<DTO: Decodable, Model>(
    data: Data,
    response: HTTPURLResponse,
    mapper: (DTO) -> Model
) -> Single<Model> {
    switch response.statusCode {
    case 200:
        guard let root = try? JSONDecoder().decode(DTO.self, from: data) else {
            return .error(NetworkError.decodeError)
        }
        return .just(mapper(root))
    case 401:
        return .error(NetworkError.unauthorized)
    case 404:
        return .error(NetworkError.notFound)
    default:
        return .error(NetworkError.invalidData(statusCode: response.statusCode))
    }
}
