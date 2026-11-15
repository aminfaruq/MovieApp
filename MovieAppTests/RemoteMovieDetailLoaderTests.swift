//
//  RemoteMovieDetailLoaderTests.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import XCTest
import RxSwift
import MovieApp

final class RemoteMovieDetailLoader {
    
    init(client: HTTPClient) {
        
    }
}

final class RemoteMovieDetailLoaderTests: XCTestCase {
    
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
        sut: RemoteMovieDetailLoader,
        spy: HTTPClientSpy
    ) {
        let spy = HTTPClientSpy()
        let sut = RemoteMovieDetailLoader(client: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
}
