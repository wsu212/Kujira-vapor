import Vapor

func routes(_ app: Application) throws {
    app.middleware.use(LogMiddleware())
    
    app.get { request async in
        "It works"
    }
    
    app.get("kujira") { request async in
        "kujira route works"
    }
}
