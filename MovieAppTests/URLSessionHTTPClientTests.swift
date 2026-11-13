//
//  URLSessionHTTPClientTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 13/11/26.
//

import RxSwift
import XCTest
import Foundation

struct UnexpectedValueRepresentation: Error {}

final class URLSessionHTTPClient {
    
    private let session: URLSession
    
    init (session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL, apiKey: String) -> Single<(Data, HTTPURLResponse)> {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return Single.create { [session] single in
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error {
                    single(.failure(error))
                    return
                }
                
                guard let _ = response as? HTTPURLResponse else {
                    single(.failure(UnexpectedValueRepresentation()))
                    return
                }
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.stub = nil
    }
    
    func test_getFromURL_requestedFromURL() {
        let url = anyURL()
        let exp = expectation(description: "wait from response")
        let apiKey = "YOUR_TMDB_V4_READ_ACCESS_TOKEN"
        
        URLProtocolStub.stub = { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer \(apiKey)")
            XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
            exp.fulfill()
            return makeResponse(statusCode: 200)
        }
        
        makeSUT().get(from: url, apiKey: apiKey)
            .subscribe()
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_deliversErrorOnFailure() {
        let expectedError = anyError()
        
        URLProtocolStub.stub = { request in
            throw expectedError
        }
        
        let exp = expectation(description: "wait from response")

        makeSUT().get(from: anyURL(), apiKey: makeApiKey())
            .subscribe(
                onFailure: { error in
                    let receivedError = error as NSError
                    XCTAssertEqual(receivedError.domain, expectedError.domain)
                    XCTAssertEqual(receivedError.code, expectedError.code)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_deliversUnexpectedValueRepresentation() {
        let nonHTTPURLResponse = URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        let data = "any-data".data(using: .utf8)!
        
        URLProtocolStub.stub = { request in
            return (data, nonHTTPURLResponse)
        }
        
        let exp = expectation(description: "wait from response")

        makeSUT().get(from: anyURL(), apiKey: makeApiKey())
            .subscribe(
                onFailure: { error in
                    XCTAssertTrue(error is UnexpectedValueRepresentation)
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
    ) -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        return sut
    }
    
    private class URLProtocolStub: URLProtocol {
        
        static var stub: ((URLRequest) throws -> (Data, URLResponse))?
        
        override class func canInit(with request: URLRequest) -> Bool {
            return URLProtocolStub.stub != nil
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }
            
            do {
                let (data, response) = try stub(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
        
        override func stopLoading() {}
    }
    
}
