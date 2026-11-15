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
            .flatMap { (data, response) in
                return .never()
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

}
