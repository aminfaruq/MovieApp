//
//  MovieListPresenter.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//
import RxSwift
import Foundation

public final class MovieListPresenter: MovieListPresenterProtocol {
    public weak var view: MovieListViewProtocol?
    public var interactor: MovieListInteractorProtocol?
    public var router: MovieListRouterProtocol?
    
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
    private var hasMore = true
    private var isLoadingMore = false
    private var movies = [MovieModel]()
    private let disposeBag = DisposeBag()
    
    public func viewDidLoad() {
        loadInitialRequest()
    }
    
    public func didLoadMore() {
        guard hasMore, !isLoadingMore else { return }
        
        let nextPage = currentPage + 1
        isLoadingMore = true
        
        view?.display(isPaginationLoading: true)
        
        interactor?.fetchMovies(withGenres: genreId, page: nextPage)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    hasMore = response.hasMore
                    currentPage = response.page
                    isLoadingMore = false
                    movies.append(contentsOf: response.results)
                    view?.display(isPaginationLoading: false)
                    view?.display(movies: movies)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    isLoadingMore = false
                    view?.display(isPaginationLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    public func didPullToRefresh() {
        loadInitialRequest()
    }
    
    public func didSelectMovie(id: Int) {
        router?.navigateToDetail(view: view, id: id)
    }
    
    private func loadInitialRequest() {
        currentPage = 1
        view?.display(isLoading: true)
        
        interactor?.fetchMovies(withGenres: genreId, page: currentPage)
            .observe(on: scheduler)
            .subscribe(
                onSuccess: { [weak self] response in
                    guard let self = self else { return }
                    hasMore = response.hasMore
                    movies = response.results
                    view?.display(isLoading: false)
                    view?.display(movies: response.results)
                },
                onFailure: { [weak self] error in
                    guard let self = self else { return }
                    
                    view?.display(isLoading: false)
                    view?.display(showErrorMessage: error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
