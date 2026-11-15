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
    
}

final class RemoteMovieListLoaderTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_init_doesNotMessageUponCreation() {
        let (_, spy) = makeSUT()
        
        XCTAssertEqual(spy.loadCallCount, 0)
        XCTAssertEqual(spy.requestedURLs, [])
        XCTAssertEqual(spy.messages, [])
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
