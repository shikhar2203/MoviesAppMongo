import NIOSSL
import Fluent
import FluentMongoDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.databases.use(.mongo(connectionString: "mongodb+srv://shikhar2203:Password1234$@moviescluster.y441aiw.mongodb.net/moviesdb?retryWrites=true&w=majority&appName=MoviesCluster"), as: .mongo)

//    app.migrations.add(CreateTodo())
    
    try app.register(collection: MoviesController())

    // register routes
    try routes(app)
}
