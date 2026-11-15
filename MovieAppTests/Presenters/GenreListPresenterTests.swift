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

public protocol GenreListPresenterProtocol: AnyObject {
    var view: GenreListViewProtocol? { get set }
    var interactor: GenreListInteractorProtocol? { get set }
    var router: GenreListRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectGenre(id: Int)
}

public final class GenreListPresenter: GenreListPresenterProtocol {
    public weak var view: GenreListViewProtocol?
    public var interactor: GenreListInteractorProtocol?
    public var router: GenreListRouterProtocol?
    
    private var scheduler: SchedulerType
    
    public init(scheduler: SchedulerType = MainScheduler.instance) {
        self.scheduler = scheduler
    }
    
    private let disposeBag = DisposeBag()
    
    public func viewDidLoad() {
        view?.display(isLoading: true)
        
        interactor?.fetchGenres()
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] result in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(genres: result)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func didSelectGenre(id: Int) {
        router?.navigateToMovieList(view: view, id: id)
    }
}

final class GenreListPresenterTests: XCTestCase {
    
    func test_init_doesNotMessagesUponCreation() {
        let (_, spy, _) = makeSUT()
        
        XCTAssertEqual(spy.interactorCallCount, 0)
        XCTAssertEqual(spy.viewMessage, [])
    }
    
    func test_viewDidLoad_deliversErrorOnFailure() {
        let (sut, spy, scheduler) = makeSUT()
        let expectedError = anyError()
        spy.interactorStub = .error(expectedError)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorCallCount, 1)
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(showErrorMessage: expectedError.localizedDescription)
        ])
    }
    
    func test_viewDidLoad_deliversResultsOnSuccess() {
        let (sut, spy, scheduler) = makeSUT()
        let genres = [makeGenre(), makeGenre()]
        spy.interactorStub = .just(genres)
        
        sut.viewDidLoad()
        scheduler.advanceBy(10)
        
        XCTAssertEqual(spy.interactorCallCount, 1)
        XCTAssertEqual(spy.viewMessage, [
            .display(isLoading: true),
            .display(isLoading: false),
            .display(genres: genres)
        ])
    }
    
    func test_didSelectGenre_bringsIdToNavigate() {
        let (sut, spy, _) = makeSUT()
        
        sut.didSelectGenre(id: 10)
        
        XCTAssertEqual(spy.loadRouterId, 10)
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
    
    private func makeGenre(id: Int = anyId(), name: String = "a-name") -> GenreModel {
        .init(id: id, name: name)
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
