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

public protocol GenreListLoader {
    func loadGenres() -> Single<[GenreModel]>
}

public final class RemoteGenreListLoader: GenreListLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func loadGenres() -> Single<[GenreModel]> {
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
                
                switch response.statusCode {
                    case 200:
                        guard let root = try? JSONDecoder().decode(RootDTO.self, from: data) else {
                            return .error(NetworkError.decodeError)
                        }
                        return .just(root.genres.map { $0.toModel() })
                    case 401:
                        return .error(NetworkError.unauthorized)
                    case 404:
                        return .error(NetworkError.notFound)
                    default:
                        return .error(NetworkError.invalidData(statusCode: response.statusCode))
                }
            }
    }
    
    private struct RootDTO: Decodable {
        let genres: [RemoteGenreDTO]
    }
    
    private struct RemoteGenreDTO: Decodable {
        private let id: Int
        private let name: String
        
        func toModel() -> GenreModel {
            .init(id: id, name: name)
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
    
    func test_loadGenres_deliversErrorNotFound() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 404))
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onFailure: { error in
                    let receivedError = error as? NetworkError
                    XCTAssertEqual(receivedError, .notFound)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadGenres_deliversErrorUnautorized() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 401))
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onFailure: { error in
                    let receivedError = error as? NetworkError
                    XCTAssertEqual(receivedError, .unauthorized)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadGenres_deliversErrorInvalidData() {
        let (sut, spy) = makeSUT()
        
        let samples = [300, 400, 500, 599]
        
        samples.forEach { code in
            spy.stub = .just(makeResponse(statusCode: code))
            
            let exp = expectation(description: "wait from response")
            sut.loadGenres()
                .subscribe(
                    onFailure: { error in
                        let receivedError = error as? NetworkError
                        XCTAssertEqual(receivedError, .invalidData(statusCode: code))
                        exp.fulfill()
                    }
                )
                .disposed(by: disposeBag)
            
            wait(for: [exp], timeout: 1.0)
        }
    }
    
    func test_loadGenres_deliversDecodeErrorOn200() {
        let (sut, spy) = makeSUT()
        let invalidJSON = "invalid-json".data(using: .utf8)!
        spy.stub = .just(makeResponse(statusCode: 200, data: invalidJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onFailure: { error in
                    let receivedError = error as? NetworkError
                    XCTAssertEqual(receivedError, .decodeError)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadGenres_deliversEmptyGenresOn200() {
        let (sut, spy) = makeSUT()
        let emtyJSON = makeGenres([])
        spy.stub = .just(makeResponse(statusCode: 200, data: emtyJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, [])
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_loadGenres_deliversGenresOn200() {
        let (sut, spy) = makeSUT()
        let genresJSON = [makeGenre(id: 1).json, makeGenre(id: 1).json]
        let genresModel = [makeGenre(id: 1).model, makeGenre(id: 1).model]
        let validJSON = makeGenres(genresJSON)
        spy.stub = .just(makeResponse(statusCode: 200, data: validJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadGenres()
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, genresModel)
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
    
    private func makeGenres(
        _ genres: [[String: Any]]
    ) -> Data {
        let json: [String: Any] = [
            "genres" : genres
        ]
        
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeGenre(
        id: Int = anyId(),
        name: String = "adventure"
    ) -> (model: GenreModel, json: [String: Any]) {
        let json: [String: Any] = [
            "id" : id,
            "name" : name
        ]
        
        let model = GenreModel(id: id, name: name)
        
        return (model, json)
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

private func anyId() -> Int {
    Int.random(in: 1...20)
}
