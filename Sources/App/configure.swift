import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: "localhost",
                port: 5432,
                username: "postgres",
                database: "kujiradb",
                tls: .disable
            )
        ),
        as: .psql
    )
    
    // register migrations
    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreateCategoriesTableMigration())
    
    // register controllers
    try app.register(collection: UserController())
    try app.register(collection: CategoryController())
    
    app.jwt.signers.use(.hs256(key: "SECRETKEY"))
    
    // register routes
    try routes(app)
}
