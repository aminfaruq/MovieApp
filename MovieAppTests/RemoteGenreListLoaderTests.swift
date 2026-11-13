//
//  RemoteGenreListLoaderTests.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

import RxSwift
import Foundation
import XCTest
import MovieApp

public struct GenreModel: Equatable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public enum NetworkError: Swift.Error, Equatable, LocalizedError {
    case connectivity
    case clientError(statusCode: Int)
    case serverError(statusCode: Int)
    case invalidData
    case decodeError
}

final class RemoteGenreListLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func loadGenres() -> Single<[GenreModel]> {
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
                return .never()
            }
    }
}

final class RemoteGenreListLoaderTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_init_doesNotMessageUponCreation() {
        let (_, spy) = makeSUT()
        
        XCTAssertEqual(spy.loadCallCount, 0)
        XCTAssertEqual(spy.requestedURLs, [])
        XCTAssertEqual(spy.messages, [])
    }
    
    func test_loadGenres_requestedFromURL() {
        let url = APIConfig.baseURL
        let (sut, spy) = makeSUT()
        let expectedURL = URL(string: url.absoluteString + "/genre/movie/list?language=en-US")!
        
        sut.loadGenres()
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertEqual(spy.messages, [.get(expectedURL, apiKey: APIConfig.readAccessToken)])
    }
    
    func test_loadGenres_deliversErrorConnectivity() {
        let (sut, spy) = makeSUT()
        spy.stub = .error(anyError())
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onFailure: { error in
                    let receivedError = error as? NetworkError
                    XCTAssertEqual(receivedError, .connectivity)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: RemoteGenreListLoader,
        client: HTTPClientSpy
    ) {
        let spy = HTTPClientSpy()
        let sut = RemoteGenreListLoader(client: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        enum Message: Equatable {
            case get(URL, apiKey: String)
        }
        
        var stub: Single<HTTPClient.Result> = .never()
        private(set) var messages = [Message]()
        private(set) var loadCallCount = 0
        private(set) var requestedURLs = [URL]()
                
        func get(from url: URL, apiKey: String) -> Single<HTTPClient.Result> {
            loadCallCount += 1
            messages.append(.get(url, apiKey: apiKey))
            requestedURLs.append(url)
            return stub
        }
    }
}
