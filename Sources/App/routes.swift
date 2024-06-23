import Vapor

func routes(_ app: Application) throws {
    // MARK: - GET
    
    app.get { request async in
        "\(request.parameters)"
    }
    
    // ~/kujira/get/string_variable
    app.get("kujira", "get", "string", ":countryCode") { request async throws in
        guard let countryCode = request.parameters.get("countryCode", as: String.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(countryCode)\n\(request.parameters)"
    }
    
    // ~/kujira/get/integer_variable
    app.get("kujira", "get", "integer", ":id") { request async throws in
        guard let id = request.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(id)"
    }
    
    // ~/kujira/get/models
    app.get("kujira", "get", "models") { request async in
        return Model.mocks
    }
    
    // ~/kujira/get/model/query?sort=asc&search=taiwan
    app.get("kujira", "get", "models", "query") { request async throws in
        let query = try request.query.decode(Query.self)
        return query
    }
    
    // MARK: - POST
    
    // ~/kujira/post/model
    app.post("kujira", "post", "model") { request async throws in
        let model = try request.content.decode(Model.self)
        return model
    }
}
