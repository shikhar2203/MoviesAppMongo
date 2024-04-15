//
//  File.swift
//  
//
//  Created by shikhar on 15/04/24.
//

import Foundation
import Vapor
import Fluent

final class Movie: Model, Content {
    
    static let schema = "movies"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "year")
    var year: Int
    
    init(){}
    
    init(id: UUID? = nil, title: String, year: Int) {
        self.id = id
        self.title = title
        self.year = year
    }
}
