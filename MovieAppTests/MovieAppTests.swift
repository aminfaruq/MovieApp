//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 13/11/26.
//

import XCTest

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

