//
//  RemoteMovieListLoaderTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 15/11/26.
//

import XCTest
import RxSwift
import Foundation
import MovieApp

final class RemoteMovieListLoader {
    
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    func loadMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovie> {
        let requestedURL = APIConfig.baseURL
            .appending(path: "discover")
            .appending(path: "movie")
            .appending(queryItems: [
                URLQueryItem(name: "with_genres", value: "\(withGenres)"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sort_by", value: "popularity.desc")
            ])
        return client.get(from: requestedURL)
            .catch({ _ in
                return .error(NetworkError.connectivity)
            })
            .flatMap { (data, response) in
                switch response.statusCode {
                    case 200:
                        guard let root = try? JSONDecoder().decode(RootDTO.self, from: data) else {
                            return .error(NetworkError.decodeError)
                        }
                        return .just(root.toModel())
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
        private let page: Int
        private let results: [RemoteMovieDTO]
        private let total_pages: Int
        private let total_results: Int
        
        func toModel() -> PaginatedResponseMovie {
            .init(
                page: page,
                totalPages: total_pages,
                totalResults: total_results,
                results: results.map { $0.toModel() }
            )
        }
    }
    
    private struct RemoteMovieDTO: Decodable {
        private let id: Int
        private let title: String
        private let overview: String
        private let poster_path: String
        private let release_date: String
        private let vote_average: Double
        
        func toModel() -> MovieModel {
            .init(
                id: id,
                title: title,
                overview: overview,
                posterPath: URL(string: APIConfig.imageBaseURL + poster_path) ?? URL(string: "about:blank")!,
                releaseDate: release_date,
                voteAverage: "\(vote_average)"
            )
        }
    }
}

final class RemoteMovieListLoaderTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_init_doesNotMessageUponCreation() {
        let (_, spy) = makeSUT()
        
        XCTAssertEqual(spy.loadCallCount, 0)
        XCTAssertEqual(spy.requestedURLs, [])
        XCTAssertEqual(spy.messages, [])
    }
    
    func test_loadMovies_requestedFromURL() {
        let url = APIConfig.baseURL
        let (sut, spy) = makeSUT()
        let expectedURL = URL(string: url.absoluteString + "/discover/movie?with_genres=28&page=1&sort_by=popularity.desc")!
        
        sut.loadMovies(withGenres: 28, page: 1)
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertEqual(spy.messages, [.get(expectedURL, apiKey: APIConfig.readAccessToken)])
    }
    
    func test_loadMovies_deliversErrorConnectivity() {
        let (sut, spy) = makeSUT()
        spy.stub = .error(anyError())
        
        let exp = expectation(description: "wait from response")
        sut.loadMovies(withGenres: 1, page: 1)
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
    
    func test_loadMovies_deliversErrorNotFound() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 404))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovies(withGenres: 1, page: 1)
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
    
    func test_loadMovies_deliversErrorUnautorized() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 401))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovies(withGenres: 1, page: 1)
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
    
    func test_loadMovies_deliversErrorInvalidData() {
        let (sut, spy) = makeSUT()
        
        let samples = [300, 400, 500, 599]
        
        samples.forEach { code in
            spy.stub = .just(makeResponse(statusCode: code))
            
            let exp = expectation(description: "wait from response")
            sut.loadMovies(withGenres: 1, page: 1)
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
    
    func test_loadMovies_deliversDecodeErrorOn200() {
        let (sut, spy) = makeSUT()
        let invalidJSON = "invalid-json".data(using: .utf8)!
        spy.stub = .just(makeResponse(statusCode: 200, data: invalidJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovies(withGenres: 1, page: 1)
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
    
    @MainActor
    func test_loadMovies_deliversMoviesOn200StatusCode() {
        let (sut, spy) = makeSUT()
        let moviesJSON = [makeMovie(id: 1).json, makeMovie(id: 2).json]
        let moviesModel = [makeMovie(id: 1).model, makeMovie(id: 2).model]
        let makePage = makePage(json: moviesJSON, model: moviesModel)
        let validJSON = try! JSONSerialization.data(withJSONObject: makePage.json)
        
        spy.stub = .just(makeResponse(statusCode: 200, data: validJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovies(withGenres: 1, page: 1)
            .subscribe(
                onSuccess: { page in
                    XCTAssertEqual(page, makePage.model)
                    XCTAssertEqual(page.results, moviesModel)
                    XCTAssertEqual(page.totalPages, makePage.model.totalPages)
                    XCTAssertEqual(page.totalResults, makePage.model.totalResults)
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
        sut: RemoteMovieListLoader,
        client: HTTPClientSpy
    ) {
        let spy = HTTPClientSpy()
        let sut = RemoteMovieListLoader(client: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
    
    private func makePage(
        json: [[String: Any]],
        model: [MovieModel],
        page: Int = 1,
        total_pages: Int = 500,
        total_results: Int = 10000,
    ) -> (
        json: [String: Any],
        model: PaginatedResponseMovie
    ) {
        let json: [String: Any] = [
            "page" : page,
            "results" : json,
            "total_pages" : total_pages,
            "total_results" : total_results
        ]
        let model = PaginatedResponseMovie(
            page: page,
            totalPages: total_pages,
            totalResults: total_results,
            results: model
        )
        
        return (json, model)
    }
    
    private func makeMovie(
        id: Int = 1,
        title: String = "a title",
        overview: String = "lorem ipsum lorem ipsum",
        posterPath: String = anyURL().absoluteString,
        releaseDate: String = "2024-12-19",
        voteAverage: Double = 7.8
    ) -> (
        json: [String: Any],
        model: MovieModel
    ) {
        let model = MovieModel(
            id: id,
            title: title,
            overview: overview,
            posterPath: URL(string: APIConfig.imageBaseURL + posterPath)!,
            releaseDate: releaseDate,
            voteAverage: "\(voteAverage)"
        )
        
        let json: [String: Any] = [
            "id" : id,
            "title" : title,
            "overview" : overview,
            "poster_path" : posterPath,
            "release_date" : releaseDate,
            "vote_average" : voteAverage,
        ]
        
        return (json, model)
    }
    
}
