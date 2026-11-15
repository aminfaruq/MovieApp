//
//  RemoteMovieDetailLoaderTests.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import XCTest
import RxSwift
import MovieApp

final class RemoteMovieDetailLoaderTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    func test_init_doesNotMessageUponCreation() {
        let (_, spy) = makeSUT()
        
        XCTAssertEqual(spy.loadCallCount, 0)
        XCTAssertEqual(spy.requestedURLs, [])
        XCTAssertEqual(spy.messages, [])
    }
    
    // MARK: - Load Movie
    func test_loadMovie_requestedFromURL() {
        let url = APIConfig.baseURL
        let (sut, spy) = makeSUT()
        let expectedURL = URL(string: url.absoluteString + "/movie/693134?language=en-US")!
        
        sut.loadMovie(id: 693134)
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertEqual(spy.messages, [.get(expectedURL, apiKey: APIConfig.readAccessToken)])
    }
    
    func test_loadMovie_deliversErrorConnectivity() {
        let (sut, spy) = makeSUT()
        spy.stub = .error(anyError())
        
        let exp = expectation(description: "wait from response")
        sut.loadMovie(id: 1)
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
    
    func test_loadMovie_deliversErrorNotFound() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 404))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovie(id: 1)
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
    
    func test_loadMovie_deliversErrorUnautorized() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 401))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovie(id: 1)
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
    
    func test_loadMovie_deliversErrorInvalidData() {
        let (sut, spy) = makeSUT()
        
        let samples = [300, 400, 500, 599]
        
        samples.forEach { code in
            spy.stub = .just(makeResponse(statusCode: code))
            
            let exp = expectation(description: "wait from response")
            sut.loadMovie(id: 1)
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
    
    func test_loadMovie_deliversDecodeErrorOn200() {
        let (sut, spy) = makeSUT()
        let invalidJSON = "invalid-json".data(using: .utf8)!
        spy.stub = .just(makeResponse(statusCode: 200, data: invalidJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovie(id: 1)
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
    
    func test_loadMovie_deliversResultsOn200StatusCode() {
        let (sut, spy) = makeSUT()
        let movie = makeMovie(genresJSON: [makeGenre(id: 1).json], genresModel: [makeGenre(id: 1).model])
        let validJSON = try! JSONSerialization.data(withJSONObject: movie.json)
        spy.stub = .just(makeResponse(statusCode: 200, data: validJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadMovie(id: 1)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result.id, movie.model.id)
                    XCTAssertEqual(result.backdropPath, movie.model.backdropPath)
                    XCTAssertEqual(result.posterPath, movie.model.posterPath)
                    XCTAssertEqual(result.tagline, movie.model.tagline)
                    XCTAssertEqual(result.overview, movie.model.overview)
                    XCTAssertEqual(result.releaseDate, movie.model.releaseDate)
                    XCTAssertEqual(result.runtime, movie.model.runtime)
                    XCTAssertEqual(result.voteAverage, movie.model.voteAverage)
                    XCTAssertEqual(result.genres, movie.model.genres)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Load Review
    func test_loadReviews_requestedFromURL() {
        let url = APIConfig.baseURL
        let (sut, spy) = makeSUT()
        let expectedURL = URL(string: url.absoluteString + "/movie/693134/reviews?page=1")!
        
        sut.loadReviews(id: 693134, page: 1)
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertEqual(spy.messages, [.get(expectedURL, apiKey: APIConfig.readAccessToken)])
    }
    
    func test_loadReviews_deliversErrorConnectivity() {
        let (sut, spy) = makeSUT()
        spy.stub = .error(anyError())
        
        let exp = expectation(description: "wait from response")
        sut.loadReviews(id: 1, page: 1)
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
    
    func test_loadReviews_deliversErrorNotFound() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 404))
        
        let exp = expectation(description: "wait from response")
        sut.loadReviews(id: 1, page: 1)
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
    
    func test_loadReviews_deliversErrorUnautorized() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 401))
        
        let exp = expectation(description: "wait from response")
        sut.loadReviews(id: 1, page: 1)
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
    
    func test_loadReviews_deliversErrorInvalidData() {
        let (sut, spy) = makeSUT()
        
        let samples = [300, 400, 500, 599]
        
        samples.forEach { code in
            spy.stub = .just(makeResponse(statusCode: code))
            
            let exp = expectation(description: "wait from response")
            sut.loadReviews(id: 1, page: 1)
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
    
    func test_loadReviews_deliversDecodeErrorOn200() {
        let (sut, spy) = makeSUT()
        let invalidJSON = "invalid-json".data(using: .utf8)!
        spy.stub = .just(makeResponse(statusCode: 200, data: invalidJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadReviews(id: 1, page: 1)
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
    func test_loadReviews_deliversResultsOn200StatusCode() {
        let (sut, spy) = makeSUT()
        let resultsJSON = [makeReview(id: "1").json, makeReview(id: "2").json]
        let resultsModel = [makeReview(id: "1").model, makeReview(id: "2").model]
        let page = makePageReviews(resultsJson: resultsJSON, resultsModel: resultsModel)
        let validJSON = try! JSONSerialization.data(withJSONObject: page.json)
        
        spy.stub = .just(makeResponse(statusCode: 200, data: validJSON))

        let exp = expectation(description: "wait from response")
        sut.loadReviews(id: 1, page: 1)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, page.model)
                    XCTAssertEqual(result.results, page.model.results)
                    XCTAssertEqual(result.results.first?.id, page.model.results.first?.id)
                    XCTAssertEqual(result.results.first?.username, page.model.results.first?.username)
                    XCTAssertEqual(result.results.first?.content, page.model.results.first?.content)
                    XCTAssertEqual(result.results.first?.rating, page.model.results.first?.rating)
                    exp.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [exp], timeout: 1.0)
    }
    
    //MARK: Trailer
    func test_loadTrailers_requestedFromURL() {
        let url = APIConfig.baseURL
        let (sut, spy) = makeSUT()
        let expectedURL = URL(string: url.absoluteString + "/movie/693134/videos?language=en-US")!
        
        sut.loadTrailers(id: 693134)
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertEqual(spy.messages, [.get(expectedURL, apiKey: APIConfig.readAccessToken)])
    }
    
    
    func test_loadTrailers_deliversErrorConnectivity() {
        let (sut, spy) = makeSUT()
        spy.stub = .error(anyError())
        
        let exp = expectation(description: "wait from response")
        sut.loadTrailers(id: 693134)
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
    
    func test_loadTrailers_deliversErrorNotFound() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 404))
        
        let exp = expectation(description: "wait from response")
        sut.loadTrailers(id: 693134)
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
    
    func test_loadTrailers_deliversErrorUnautorized() {
        let (sut, spy) = makeSUT()
        spy.stub = .just(makeResponse(statusCode: 401))
        
        let exp = expectation(description: "wait from response")
        sut.loadTrailers(id: 693134)
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
    
    func test_loadTrailers_deliversErrorInvalidData() {
        let (sut, spy) = makeSUT()
        
        let samples = [300, 400, 500, 599]
        
        samples.forEach { code in
            spy.stub = .just(makeResponse(statusCode: code))
            
            let exp = expectation(description: "wait from response")
            sut.loadTrailers(id: 693134)
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
    
    func test_loadTrailers_deliversDecodeErrorOn200() {
        let (sut, spy) = makeSUT()
        let invalidJSON = "invalid-json".data(using: .utf8)!
        spy.stub = .just(makeResponse(statusCode: 200, data: invalidJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadTrailers(id: 693134)
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
    func test_loadTrailers_deliversResultsOn200StatusCode() {
        let (sut, spy) = makeSUT()
        let trailer = makeTrailer()
        let validJSON = makeTrailers([trailer.json])
        
        spy.stub = .just(makeResponse(statusCode: 200, data: validJSON))
        
        let exp = expectation(description: "wait from response")
        sut.loadTrailers(id: 693134)
            .subscribe(
                onSuccess: { result in
                    XCTAssertEqual(result, [trailer.model])
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
        sut: RemoteMovieDetailLoader,
        spy: HTTPClientSpy
    ) {
        let spy = HTTPClientSpy()
        let sut = RemoteMovieDetailLoader(client: spy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        return (sut, spy)
    }
    
    private func makeMovie(
        id: Int = 1,
        title: String = "a-title",
        tagline: String = "a-tagline",
        overview: String = "a-overview",
        releaseDate: String = "a-releaseDate",
        runtime: Int = 459,
        voteAverage: Double = 9.9,
        posterPath: String = "a-posterPath",
        backdropPath: String = "a-backdropPath",
        genresJSON: [[String: Any]],
        genresModel: [GenreModel]
    ) -> (
        json: [String: Any],
        model: MovieDetailModel
    ) {
        let model = MovieDetailModel(
            id: id,
            title: title,
            tagline: tagline,
            overview: overview,
            releaseDate: releaseDate,
            runtime: "\(runtime)",
            voteAverage: "\(voteAverage)",
            genres: genresModel,
            posterPath: URL(string: APIConfig.imageBaseURL + posterPath)!,
            backdropPath: URL(string: APIConfig.imageBaseURL + backdropPath)!
        )
        
        let json: [String: Any] = [
            "id": id,
            "title": title,
            "tagline": tagline,
            "overview": overview,
            "release_date": releaseDate,
            "runtime": runtime,
            "vote_average": voteAverage,
            "genres": genresJSON,
            "poster_path": posterPath,
            "backdrop_path": backdropPath
        ]
        
        return (json, model)
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
    
    private func makePageReviews(
        id: Int = anyId(),
        page: Int = 1,
        total_pages: Int = 1,
        total_results: Int = 1,
        resultsJson: [[String: Any]],
        resultsModel: [MovieReviewModel]
    ) -> (
        model: PaginatedResponseMovieReviewModel,
        json: [String: Any]
    ) {
        let json: [String: Any] = [
            "id" : id,
            "page" : page,
            "results": resultsJson,
            "total_pages": total_pages,
            "total_results": total_results,
        ]
        
        let model = PaginatedResponseMovieReviewModel(
            id: id,
            page: page,
            totalPages: total_pages,
            totalResults: total_results,
            results: resultsModel)
        
        return (model, json)
    }
    
    private func makeReview(
        id: String = "an-id",
        username: String = "username",
        rating: Int = 9,
        content: String = "a content",
    ) -> (
        json: [String: Any],
        model: MovieReviewModel
    ){
        let authorDetailJSON: [String: Any] = [
            "username": username,
            "rating": rating
        ]
        
        let json: [String: Any] = [
            "id": id,
            "content": content,
            "author_details": authorDetailJSON
        ]
        
        let model = MovieReviewModel(
            id: id,
            username: username,
            rating: "\(rating)",
            content: content
        )
        
        return (json, model)
    }
    
    private func makeTrailers(_ results: [[String: Any]]) -> Data {
        let json: [String: Any] = [
            "results": results
        ]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeTrailer(
        id: String = "65a8b2104b0c63012f6e1a2b",
        name: String =  "Official Trailer",
        key: String = "Way9Dexny3w",
        site: String = "YouTube",
        size: Int = 1080,
        type: String = "Trailer",
        official: Bool = true
    ) -> (model: TrailerModel, json: [String: Any]) {
        let model = TrailerModel(
            id: id,
            name: name,
            key: key,
            site: site,
            size: size,
            type: type,
            official: official
        )
        
        let json: [String: Any] = [
            "id": id,
            "name": name,
            "key": key,
            "site": site,
            "size": size,
            "type": type,
            "official": official
        ]
        
        return (model, json)
    }
}
