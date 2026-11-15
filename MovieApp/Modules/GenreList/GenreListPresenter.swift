//
//  GenreListPresenter.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//
import RxSwift
import Foundation

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
