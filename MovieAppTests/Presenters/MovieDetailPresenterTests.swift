//
//  MovieDetailPresenterTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 16/11/26.
//

import XCTest
import RxTest
import RxSwift
import MovieApp
import Foundation

public protocol MovieDetailViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(movie: MovieDetailModel)
    func display(trailerURL: URL?)
    func display(reviews: [MovieReviewModel])
    func display(isPaginationLoading: Bool)
    func display(showErrorMessage: String)
}

public protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorProtocol? { get set }
    
    func viewDidLoad()
    func didLoadMore()
}

public final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    public weak var view: MovieDetailViewProtocol?
    public var interactor: MovieDetailInteractorProtocol?
    
    private let id: Int
    private let scheduler: SchedulerType
    
    public init(
        id: Int,
        scheduler: SchedulerType = MainScheduler.instance
    ) {
        self.id = id
        self.scheduler = scheduler
    }
    
    private var currentPage = 1
    private var hasMore = true
    private var isLoadingMore = false
    private var reviews = [MovieReviewModel]()

    private let disposeBag = DisposeBag()
    
    public func viewDidLoad() {
        loadMovieDetail()
        loadTrailer()
        loadInitalReviews()
    }
    
    public func didLoadMore() {
        guard hasMore, !isLoadingMore else { return }
        
        let nextPage = currentPage + 1
        isLoadingMore = true
        view?.display(isPaginationLoading: true)
        
        interactor?.fetchReviews(id: id, page: nextPage)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    isLoadingMore = false
                    currentPage = response.page
                    hasMore = response.hasMore
                    view?.display(isPaginationLoading: false)
                    reviews.append(contentsOf: response.results)
                    view?.display(reviews: reviews)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    isLoadingMore = false
                    view?.display(isPaginationLoading: false)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadMovieDetail() {
        view?.display(isLoading: true)
        
        interactor?.fetchMovie(id: id)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(movie: response)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadTrailer() {
        interactor?.fetchTrailers(id: id)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self]  results in
                    guard let self = self else { return }
                    
                    let trailer = results.first { $0.site == "YouTube" && $0.type == "Trailer" }
                    let url = trailer.flatMap { URL(string: "\(APIConfig.youtubeEmbedBaseURL)/\($0.key)") }
                    view?.display(trailerURL: url)
                },
                
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(trailerURL: nil)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func loadInitalReviews() {
        currentPage = 1
        interactor?.fetchReviews(id: id, page: currentPage)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    hasMore = response.hasMore
                    reviews = response.results
                    view?.display(reviews: response.results)
                },
                onFailure: {  [weak self] error in
                    guard let self = self else { return }

                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
}

final class MovieDetailPresenterTests: XCTestCase {

    func test_init_doesNotMessagesUponCreation() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertEqual(spy.interactorCallCount, 0)
        XCTAssertEqual(spy.interactorMessage, [])
        XCTAssertEqual(spy.viewMessage, [])
    }
    
    func test_viewDidLoad_deliversErrorOnFailure() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        let expectedError = anyError()
        spy.loadMovieStub = .error(expectedError)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1)
        ])
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(showErrorMessage: expectedError.localizedDescription)
        ])
    }
    
    func test_viewDidLoad_deliversResponseOnSuccess() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let movie = makeMovie(genresModel: [makeGenre()])
        spy.loadMovieStub = .just(movie)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1)
        ])
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(movie: movie)
        ])
    }
    
    func test_viewDidLoad_deliversTrailerOnError() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        spy.loadTrailersStub = .error(anyError())
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1)
        ])
        XCTAssertTrue(spy.viewMessage.contains(.display(trailer: nil)))
    }
    
    func test_viewDidLoad_deliversTrailerOnSuccess() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let key = "Way9Dexny3w"
        let expectedURL = URL(string: "https://www.youtube.com/embed/\(key)")!
        let youtubeTrailer = makeTrailer(key: key, site: "youtube", type: "trailer")
        let nonYoutubeTrailer = makeTrailer()
        let trailers = [youtubeTrailer, nonYoutubeTrailer]
        spy.loadTrailersStub = .just(trailers)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1)
        ])
        XCTAssertTrue(spy.viewMessage.contains(.display(trailer: expectedURL)))
    }
    
    func test_viewDidLoad_deliversReviewsOnFailure() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        let expectedError = anyError()
        spy.loadReviewsStub = .error(expectedError)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertTrue(spy.viewMessage.contains(.display(showErrorMessage: expectedError.localizedDescription)))
    }
    
    func test_viewDidLoad_deliversReviewsOnSuccess() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        let reviews = [makeReview(), makeReview()]
        let page = makePageReviews(page: 1, total_pages: 1, resultsModel: reviews)
        spy.loadReviewsStub = .just(page)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertTrue(spy.viewMessage.contains(.display(reviews: reviews)))
    }
    
    func test_didLoadMore_requestNextPage() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let review = makeReview()
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 3, resultsModel: [review]))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .just(makePageReviews(page: 2, total_pages: 3, resultsModel: [review]))
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .just(makePageReviews(page: 3, total_pages: 3, resultsModel: [review]))
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1),
            .fetchReviews(id: id, page: 2),
            .fetchReviews(id: id, page: 3)
        ])
        XCTAssertTrue(spy.viewMessage.contains(.display(isPaginationLoading: true)))
        XCTAssertTrue(spy.viewMessage.contains(.display(isPaginationLoading: false)))
    }
    
    func test_didLoadMore_doNotRequestWhenHasMoreIsFalse() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let review = makeReview()
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 1, resultsModel: [review]))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1)
        ])
    }
    
    func test_didLoadMore_ignoresRequestWhenDuplicated() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let review = makeReview()
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 3, resultsModel: [review]))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .never()
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1),
            .fetchReviews(id: id, page: 2)
        ])
    }
    
    func test_didLoadMore_stopAtLastPage() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let review = makeReview()
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 2, resultsModel: [review]))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .just(makePageReviews(page: 2, total_pages: 2, resultsModel: [review]))
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1),
            .fetchReviews(id: id, page: 2)
        ])
    }
    
    func test_didLoadMore_appendingNextPage() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        let review1 = makeReview(id: "abc")
        let review2 = makeReview(id: "cba")
        
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 2, resultsModel: [review1]))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .just(makePageReviews(page: 2, total_pages: 2, resultsModel: [review2]))
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovie(id: id),
            .fetchTrailers(id: id),
            .fetchReviews(id: id, page: 1),
            .fetchReviews(id: id, page: 2)
        ])
        XCTAssertTrue(spy.viewMessage.contains(.display(reviews: [review1, review2])))
    }
    
    func test_didLoadMore_retryAfterFailure() {
        let (sut, spy, scheduler) = makeSUT()
        
        spy.loadReviewsStub = .just(makePageReviews(page: 1, total_pages: 3, resultsModel: [makeReview()]))

        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.loadReviewsStub = .error(anyError())
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorCallCount, 5)
    }
        
    func test_view_shouldHaveBeenDeallocatedWhenReleased() {
        let (sut, _, _) = makeSUT()
        
        do {
            let tempView = ViewSpy()
            sut.view = tempView
            XCTAssertNotNil(sut.view)
        }
        
        XCTAssertNil(sut.view)
    }
    
    //MARK: Helpers
    private func makeSUT(
        id: Int = anyId(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: MovieDetailPresenter,
        spy: ViewSpy,
        scheduler: TestScheduler
    ) {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = MovieDetailPresenter(id: id, scheduler: scheduler)
        let spy = ViewSpy()
        
        sut.view = spy
        sut.interactor = spy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy, scheduler)
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
        genresModel: [GenreModel]
    ) -> MovieDetailModel {
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
        
        return model
    }
    
    private func makeTrailer(
        id: String = "65a8b2104b0c63012f6e1a2b",
        name: String =  "Official Trailer",
        key: String = "Way9Dexny3w",
        site: String = "YouTube",
        size: Int = 1080,
        type: String = "Trailer",
        official: Bool = true
    ) -> TrailerModel {
        let model = TrailerModel(
            id: id,
            name: name,
            key: key,
            site: site,
            size: size,
            type: type,
            official: official
        )
        return model
    }
    
    private func makePageReviews(
        id: Int = anyId(),
        page: Int ,
        total_pages: Int,
        total_results: Int = 1,
        resultsModel: [MovieReviewModel]
    ) -> PaginatedResponseMovieReviewModel {
        
        
        let model = PaginatedResponseMovieReviewModel(
            id: id,
            page: page,
            totalPages: total_pages,
            totalResults: total_results,
            results: resultsModel)
        
        return model
    }
    
    private func makeReview(
        id: String = "an-id",
        username: String = "username",
        rating: Int = 9,
        content: String = "a content",
    ) -> MovieReviewModel {
        let model = MovieReviewModel(
            id: id,
            username: username,
            rating: "\(rating)",
            content: content
        )
        
        return model
    }
    
    private func makeGenre(id: Int = anyId(), name: String = "a-name") -> GenreModel {
        .init(id: id, name: name)
    }
    
    
    private class ViewSpy: MovieDetailViewProtocol, MovieDetailInteractorProtocol {
             
        //MARK: - View
        enum ViewMessage: Equatable {
            case display(isLoading: Bool)
            case display(movie: MovieDetailModel)
            case display(trailer: URL?)
            case display(reviews: [MovieReviewModel])
            case display(isPaginationLoading: Bool)
            case display(showErrorMessage: String)
        }
        
        private(set) var viewMessage = [ViewMessage]()
        
        func display(isLoading: Bool) {
            viewMessage.append(.display(isLoading: isLoading))
        }
        
        func display(movie: MovieDetailModel) {
            viewMessage.append(.display(movie: movie))
        }
        
        func display(trailerURL: URL?) {
            viewMessage.append(.display(trailer: trailerURL))
        }
        
        func display(reviews: [MovieReviewModel]) {
            viewMessage.append(.display(reviews: reviews))
        }
        
        func display(isPaginationLoading: Bool) {
            viewMessage.append(.display(isPaginationLoading: isPaginationLoading))
        }
        
        func display(showErrorMessage: String) {
            viewMessage.append(.display(showErrorMessage: showErrorMessage))
        }
        
        //MARK: - Interactor
        enum InteractorMessage: Equatable {
            case fetchMovie(id: Int)
            case fetchTrailers(id: Int)
            case fetchReviews(id: Int, page: Int)
        }
        private(set) var interactorMessage = [InteractorMessage]()
        private(set) var interactorCallCount = 0
        var loadMovieStub: Single<MovieDetailModel> = .never()
        var loadReviewsStub: Single<PaginatedResponseMovieReviewModel> = .never()
        var loadTrailersStub: Single<[TrailerModel]> = .never()
        
        func fetchMovie(id: Int) -> Single<MovieDetailModel> {
            interactorCallCount += 1
            interactorMessage.append(.fetchMovie(id: id))
            return loadMovieStub
        }
        
        func fetchTrailers(id: Int) -> Single<[TrailerModel]> {
            interactorCallCount += 1
            interactorMessage.append(.fetchTrailers(id: id))
            return loadTrailersStub
        }
        
        func fetchReviews(id: Int, page: Int) -> Single<PaginatedResponseMovieReviewModel> {
            interactorCallCount += 1
            interactorMessage.append(.fetchReviews(id: id, page: page))
            return loadReviewsStub
        }
        
    }

}
