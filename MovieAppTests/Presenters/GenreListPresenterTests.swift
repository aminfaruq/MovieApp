//
//  GenreListPresenterTests.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import XCTest
import RxSwift
import RxTest
import Foundation
import MovieApp

public protocol GenreListViewProtocol: AnyObject {
    func display(isLoading: Bool)
    func display(genres: [GenreModel])
    func display(showErrorMessage: String)
}

public protocol GenreListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    
    func navigateToMovieList(view: GenreListViewProtocol?, id: Int)
}

final class GenreListPresenter {
    var view: GenreListViewProtocol?
    var interactor: GenreListInteractorProtocol?
    var router: GenreListRouterProtocol?
    
    private var scheduler: SchedulerType
    
    public init(scheduler: SchedulerType = MainScheduler.instance) {
        self.scheduler = scheduler
    }
}

final class GenreListPresenterTests: XCTestCase {
    
    func test_init_doesNotMessagesUponCreation() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertEqual(spy.interactorCallCount, 0)
        XCTAssertEqual(spy.viewMessage, [])
    }
    
    //MARK: Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (
        sut: GenreListPresenter,
        spy: ViewSpy,
        scheduler: TestScheduler
    ) {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = GenreListPresenter(scheduler: scheduler)
        let spy = ViewSpy()
        
        sut.view = spy
        sut.interactor = spy
        sut.router = spy
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy, scheduler)
    }
    
    private class ViewSpy: GenreListViewProtocol, GenreListInteractorProtocol, GenreListRouterProtocol {
    
        //MARK: - View
        enum ViewMessage: Equatable {
            case display(isLoading: Bool)
            case display(genres: [GenreModel])
            case display(showErrorMessage: String)
        }
        private(set) var viewMessage = [ViewMessage]()
        
        func display(isLoading: Bool) {
            viewMessage.append(.display(isLoading: isLoading))
        }
        
        func display(genres: [GenreModel]) {
            viewMessage.append(.display(genres: genres))
        }
        
        func display(showErrorMessage: String) {
            viewMessage.append(.display(showErrorMessage: showErrorMessage))
        }
        
        //MARK: - Interactor
        private(set) var interactorCallCount = 0
        var interactorStub: Single<[GenreModel]> = .never()
        
        
        func fetchGenres() -> Single<[GenreModel]> {
            interactorCallCount += 1
            return interactorStub
        }
        
        //MARK: - Router
        var loadRouterId = 0
        static func createModule() -> UIViewController {
            UIViewController()
        }
        
        func navigateToMovieList(view: (any GenreListViewProtocol)?, id: Int) {
            loadRouterId = id
        }
    }

}
