//
//  URLSessionHTTPClientTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 13/11/26.
//

import RxSwift
import XCTest
import Foundation

final class URLSessionHTTPClient {
    
    init (session: URLSession = .shared) {
        
    }
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    
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
