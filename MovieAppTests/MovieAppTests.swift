//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 13/11/26.
//
import MovieApp
import XCTest
import RxSwift

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Should have been deallocated. Pottential memory leaks", file: file, line: line)
        }
    }
}

func makeResponse(statusCode: Int, data: Data = Data(), headers: [String: String]? = [:]) -> (Data, HTTPURLResponse) {
    let response = HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
    return (data, response)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyError() -> NSError {
    return NSError(domain: "an error", code: 404)
}

func anyData() -> Data {
    Data()
}

func anyId() -> Int {
    Int.random(in: 1...20)
}

func makeApiKey() -> String {
    let apiKey = "YOUR_TMDB_V4_READ_ACCESS_TOKEN"
    return apiKey
}

class HTTPClientSpy: HTTPClient {
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

