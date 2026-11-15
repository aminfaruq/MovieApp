//
//  TrailerModel.swift
//  MovieApp
//
//  Created by Amin faruq on 15/11/26.
//

public struct TrailerModel: Equatable {
    public let id: String
    public let name: String
    public let key: String
    public let site: String
    public let size: Int
    public let type: String
    public let official: Bool
    
    public init(id: String, name: String, key: String, site: String, size: Int, type: String, official: Bool) {
        self.id = id
        self.name = name
        self.key = key
        self.site = site
        self.size = size
        self.type = type
        self.official = official
    }
}
