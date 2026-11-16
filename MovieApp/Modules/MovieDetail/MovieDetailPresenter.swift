//
//  MovieDetailPresenter.swift
//  MovieApp
//
//  Created by Amin faruq on 16/11/26.
//
import RxSwift
import Foundation

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
                    ?? results.first { $0.site == "YouTube" && $0.type == "Teaser" }
                    ?? results.first { $0.site == "YouTube" }
                    
                    let url = trailer.flatMap { URL(string: "\(APIConfig.youtubeEmbedBaseURL)/\($0.key)") }
                    self.view?.display(trailerURL: url)
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
