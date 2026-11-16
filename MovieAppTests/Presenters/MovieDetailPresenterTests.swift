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
    func display(review: MovieReviewModel)
    func display(isPaginationLoading: Bool)
    func display(showErrorMessage: String)
}


final class MovieDetailPresenter {
    var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorProtocol?
    
    private let id: Int
    private let scheduler: SchedulerType
    
    public init(
        id: Int,
        scheduler: SchedulerType = MainScheduler.instance
    ) {
        self.id = id
        self.scheduler = scheduler
    }
    
    private let disposeBag = DisposeBag()
    
    func viewDidLoad() {
        loadMovieDetail()
    }
    
    func loadMovieDetail() {
        view?.display(isLoading: true)
        
        interactor?.fetchMovie(id: id)
            .observe(on: scheduler)
            .subscribe(
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
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
            .fetchMovie(id: id)
        ])
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(showErrorMessage: expectedError.localizedDescription)
        ])
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
    
    private class ViewSpy: MovieDetailViewProtocol, MovieDetailInteractorProtocol {
             
        //MARK: - View
        enum ViewMessage: Equatable {
            case display(isLoading: Bool)
            case display(movie: MovieDetailModel)
            case display(trailer: URL?)
            case display(review: MovieReviewModel)
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
        
        func display(review: MovieReviewModel) {
            viewMessage.append(.display(review: review))
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
