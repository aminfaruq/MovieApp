//
//  MovieListPresenterTests.swift
//  MovieAppTests
//
//  Created by Amin faruq on 16/11/26.
//

import XCTest
import RxTest
import RxSwift
import MovieApp
import Foundation

public protocol MovieListViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(movies: [MovieModel])
    func display(showErrorMessage: String)
    func display(isPaginationLoading: Bool)
}

public protocol MovieListRouterProtocol: AnyObject {
    
    static func createModule(genre: GenreModel) -> UIViewController
    
    func navigateToDetail(view: MovieListViewProtocol?, id: Int)
}

final class MovieListPresenter {
    var view: MovieListViewProtocol?
    var interactor: MovieListInteractorProtocol?
    var router: MovieListRouterProtocol?
    
    private var genreId: Int
    private var scheduler: SchedulerType
    
    public init(
        genreId: Int,
        scheduler: SchedulerType = MainScheduler.instance
    ) {
        self.scheduler = scheduler
        self.genreId = genreId
    }
    
    private var currentPage = 1
    private let disposeBag = DisposeBag()
    
    public func viewDidLoad() {
        view?.display(isLoading: true)
        
        interactor?.fetchMovies(withGenres: genreId, page: 1)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] page in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(movies: page.results)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func didLoadMore() {
        let nextPage = currentPage + 1
        view?.display(isPaginationLoading: true)
        
        interactor?.fetchMovies(withGenres: genreId, page: nextPage)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    
                    currentPage = response.page
                    view?.display(isPaginationLoading: false)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isPaginationLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}

final class MovieListPresenterTests: XCTestCase {
    
    func test_init_doesNotMessagesUponCreation() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertEqual(spy.interactorCallCount, 0)
        XCTAssertEqual(spy.loadRouterId, 0)
        XCTAssertEqual(spy.viewMessage, [])
    }
    
    func test_viewDidLoad_deliversErrorOnFailure() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let expectedError = anyError()
        spy.interactorStub = .error(expectedError)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorCallCount, 1)
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovies(withGenres: id, page: 1)
        ])
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(showErrorMessage: expectedError.localizedDescription)
        ])
    }
    
    func test_viewDidLoad_deliversResultOnSuccess() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let movie = makeMovie()
        let page = makePage(model: [movie], page: 1, total_pages: 1)
        spy.interactorStub = .just(page)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorCallCount, 1)
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovies(withGenres: id, page: 1)
        ])
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(movies: [movie])
        ])
    }
    
    func test_didLoadMore_requestNextPage() {
        let id = anyId()
        let (sut, spy, scheduler) = makeSUT(id: id)
        
        let movie = makeMovie()
        spy.interactorStub = .just(makePage(model: [movie], page: 1, total_pages: 3))
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        spy.interactorStub = .just(makePage(model: [movie], page: 2, total_pages: 3))
        sut.didLoadMore()
        scheduler.advanceBy(10)
        
        spy.interactorStub = .just(makePage(model: [movie], page: 3, total_pages: 3))
        sut.didLoadMore()
        scheduler.advanceBy(10)

        XCTAssertEqual(spy.interactorCallCount, 3)
        XCTAssertEqual(spy.interactorMessage, [
            .fetchMovies(withGenres: id, page: 1),
            .fetchMovies(withGenres: id, page: 2),
            .fetchMovies(withGenres: id, page: 3)
        ])
        XCTAssertTrue(spy.viewMessage.contains(.display(isPaginationLoading: true)))
        XCTAssertTrue(spy.viewMessage.contains(.display(isPaginationLoading: false)))
    }
    
   
    //MARK: Helpers
    private func makeSUT(
        id: Int = anyId(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: MovieListPresenter,
        spy: ViewSpy,
        scheduler: TestScheduler
    ) {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = MovieListPresenter(genreId: id, scheduler: scheduler)
        let spy = ViewSpy()
        
        sut.view = spy
        sut.interactor = spy
        sut.router = spy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy, scheduler)
    }
    
    private func makePage(
        model: [MovieModel],
        page: Int,
        total_pages: Int,
        total_results: Int = 1,
    ) -> PaginatedResponseMovieModel {
        let model = PaginatedResponseMovieModel(
            page: page,
            totalPages: total_pages,
            totalResults: total_results,
            results: model
        )
        
        return model
    }
    
    private func makeMovie(
        id: Int = 1,
        title: String = "a title",
        overview: String = "lorem ipsum lorem ipsum",
        posterPath: String = anyURL().absoluteString,
        releaseDate: String = "2024-12-19",
        voteAverage: Double = 7.8
    ) -> MovieModel {
        let model = MovieModel(
            id: id,
            title: title,
            overview: overview,
            posterPath: URL(string: APIConfig.imageBaseURL + posterPath)!,
            releaseDate: releaseDate,
            voteAverage: "\(voteAverage)"
        )
            
        return model
    }
    
    private class ViewSpy: MovieListViewProtocol, MovieListInteractorProtocol, MovieListRouterProtocol {
        
        //MARK: - View
        enum ViewMessage: Equatable {
            case display(isLoading: Bool)
            case display(movies: [MovieModel])
            case display(showErrorMessage: String)
            case display(isPaginationLoading: Bool)
        }
        
        private(set) var viewMessage = [ViewMessage]()
        
        func display(isLoading: Bool) {
            viewMessage.append(.display(isLoading: isLoading))
        }
        
        func display(movies: [MovieModel]) {
            viewMessage.append(.display(movies: movies))
        }
        
        func display(showErrorMessage: String) {
            viewMessage.append(.display(showErrorMessage: showErrorMessage))
        }
        
        func display(isPaginationLoading: Bool) {
            viewMessage.append(.display(isPaginationLoading: isPaginationLoading))
        }
        
        //MARK: - Interactor
        enum InteractorMessage: Equatable {
            case fetchMovies(withGenres: Int, page: Int)
        }
        private(set) var interactorMessage = [InteractorMessage]()
        private(set) var interactorCallCount = 0
        var interactorStub: Single<PaginatedResponseMovieModel> = .never()
        
        func fetchMovies(withGenres: Int, page: Int) -> Single<PaginatedResponseMovieModel> {
            interactorCallCount += 1
            interactorMessage.append(.fetchMovies(withGenres: withGenres, page: page))
            return interactorStub
        }
        
        //MARK: - Router
        private(set) var loadRouterId = 0
        
        static func createModule(genre: GenreModel) -> UIViewController {
            UIViewController()
        }
        
        func navigateToDetail(view: (any MovieListViewProtocol)?, id: Int) {
            loadRouterId = id
        }
    }

}
