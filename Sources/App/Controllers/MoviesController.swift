//
//  File.swift
//  
//
//  Created by shikhar on 15/04/24.
//

import Foundation
import Vapor
import Fluent
import FluentMongoDriver

class MoviesController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        
        let api = routes.grouped("api")
        
        // POST "/api/movies"
        api.post("movies", use: createMovie)
        
        // GET "/api/movies"
        api.get("movies", use: getAll)
        
        // GET "/api/movies/:movieId"
        api.get("movies", ":movieId", use: getById)
        
        // DELETE "/api/movies/:movieId"
        api.delete("movies", ":movieId", use: deleteMovie)
        
        //UPDATE "/api/movies/:movieId"
        api.put("movies", ":movieId", use: updateMovie)
        
    }
    
    func createMovie(req: Request) async throws -> Movie {
        
        let movie = try req.content.decode(Movie.self)
        try await movie.save(on: req.db)
        
        return movie
    }
    
    func getAll(req: Request) async throws -> [Movie] {
        return try await Movie.query(on: req.db)
            .all()
    }
    
    func getById(req: Request) async throws -> Movie {
        
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else{
            throw Abort(.notFound, reason: "The movie Id is not found.")
        }
        
        guard let movie = try await Movie.find(movieId, on: req.db) else{
            throw Abort(.notFound, reason: "The movie Id \(movieId) is not found in the database")
        }
        
        return movie
    }
    
    func deleteMovie(req: Request) async throws -> Movie {
        
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else{
            throw Abort(.notFound, reason: "The movie Id is not found.")
        }
        
        guard let movie = try await Movie.find(movieId, on: req.db) else{
            throw Abort(.notFound, reason: "The movie Id \(movieId) is not found in the database")
        }
        
        try await movie.delete(on: req.db)
        return movie
    }
    
    func updateMovie(req: Request) async throws -> Movie {
        
        guard let movieId = req.parameters.get("movieId", as: UUID.self) else{
            throw Abort(.notFound, reason: "Not a valid ID.")
        }
        
        guard let movie = try await Movie.find(movieId, on: req.db) else {
            throw Abort(.notFound, reason: "The movie could not be found.")
        }
        
        let updateMovie = try req.content.decode(Movie.self)
        
        movie.title = updateMovie.title
        movie.year = updateMovie.year
        
        try await movie.update(on: req.db)
        return movie
    }
    
}
