import Vapor

func routes(_ app: Application) throws {
    app.middleware.use(LogMiddleware())
    
    // To ensure AuthenticationMiddleware is only get executed when client calls "members" endpoint.
    app.grouped(AuthenticationMiddleware()).group("members") { route in
        route.get { request async in
            return "Members Index"
        }
        route.get("hello") { request async in
            return "Members Hello"
        }
    }
    
    app.get { request async in
        "It works"
    }
    
    app.get("kujira") { request async in
        "kujira route works"
    }
}
