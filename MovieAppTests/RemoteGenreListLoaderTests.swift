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

final class RemoteGenreListLoader {
    
    init(client: HTTPClient) {
        
    }
}

final class RemoteGenreListLoaderTests: XCTestCase {
    
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
        sut: RemoteGenreListLoader,
        client: HTTPClientSpy
    ) {
        let spy = HTTPClientSpy()
        let sut = RemoteGenreListLoader(client: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, spy)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        enum Message: Equatable {
            case get(URL, apiKey: String)
        }
        
        private var stub: Single<HTTPClient.Result> = .never()
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
