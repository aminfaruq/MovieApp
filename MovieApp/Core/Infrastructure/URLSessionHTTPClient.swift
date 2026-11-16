//
//  URLSessionHTTPClient.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

import Foundation
import RxSwift

public struct UnexpectedValueRepresentation: Error {}

public protocol HTTPClient {
    typealias Result = (Data, HTTPURLResponse)
    
    func get(from url: URL, apiKey: String) -> Single<Result>
}

public extension HTTPClient {
    func get(from url: URL) -> Single<Result> {
        get(from: url, apiKey: APIConfig.readAccessToken)
    }
}

public final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init (session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(from url: URL, apiKey: String) -> Single<HTTPClient.Result> {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return Single.create { [session] single in
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    single(.failure(UnexpectedValueRepresentation()))
                    return
                }
                
                single(.success((data, response)))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
