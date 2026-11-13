//
//  GenreModel.swift
//  MovieApp
//
//  Created by Amin faruq on 13/11/26.
//

public struct GenreModel: Equatable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
