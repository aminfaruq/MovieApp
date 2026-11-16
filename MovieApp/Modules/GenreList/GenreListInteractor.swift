//
//  GenreListInteractor.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

import RxSwift

public protocol GenreListInteractorProtocol: AnyObject {
    func fetchGenres() -> Single<[GenreModel]>
}

public final class GenreListInteractor: GenreListInteractorProtocol {
    
    private let loader: GenreListLoader
    
    public init(loader: GenreListLoader) {
        self.loader = loader
    }
    
    public func fetchGenres() -> Single<[GenreModel]> {
        return loader.loadGenres()
    }
}
