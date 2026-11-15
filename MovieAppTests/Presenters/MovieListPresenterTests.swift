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
    
    private var scheduler: SchedulerType
    
    public init(scheduler: SchedulerType = MainScheduler.instance) {
        self.scheduler = scheduler
    }
}

final class MovieListPresenterTests: XCTestCase {
    
    func test_init_doesNotMessagesUponCreation() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertEqual(spy.interactorCallCount, 0)
        XCTAssertEqual(spy.loadRouterId, 0)
        XCTAssertEqual(spy.viewMessage, [])
    }
   
    //MARK: Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: MovieListPresenter,
        spy: ViewSpy,
        scheduler: TestScheduler
    ) {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = MovieListPresenter(scheduler: scheduler)
        let spy = ViewSpy()
        
        sut.view = spy
        sut.interactor = spy
        sut.router = spy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy, scheduler)
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
