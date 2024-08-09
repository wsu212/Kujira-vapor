import Vapor
import Fluent
import FluentPostgresDriver
import JWT

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let databaseURL = Environment.get("DATABASE_URL"), var postgresConfig = PostgresConfiguration(url: databaseURL) {
        postgresConfig.tlsConfiguration = .makeClientConfiguration()
        postgresConfig.tlsConfiguration?.certificateVerification = .none
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        app.databases.use(
            .postgres(
                configuration: .init(
                    hostname: Environment.get("DB_HOST_NAME") ?? "localhost",
                    port: 5432,
                    username: Environment.get("DB_USER_NAME") ?? "postgres",
                    database: Environment.get("DB_NAME") ?? "kujiradb",
                    tls: .disable
                )
            ),
            as: .psql
        )
    }
    
    // register migrations
    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreateCategoriesTableMigration())
    app.migrations.add(CreateItemsTableMigration())
    app.migrations.add(CreateRecipesTableMigration())
    app.migrations.add(CreateIngredientsTableMigration())
    app.migrations.add(AddIsCheckedItemsTableMigration())
    app.migrations.add(CreateRecipesTableMigration_v2())
    app.migrations.add(CreateRecipesTableMigration_v3())
    app.migrations.add(CreateRecipesTableMigration_v4())
    app.migrations.add(CreateRecipesTableMigration_v5())
    app.migrations.add(CreateRecipesTableMigration_v6())
    
    // register controllers
    try app.register(collection: UserController())
    try app.register(collection: CategoryController())
    try app.register(collection: RecipeController())
    
    app.jwt.signers.use(.hs256(key: Environment.get("JWT_SIGN_KEY") ?? "SECRETKEY"))
    
    // register routes
    try routes(app)
}
