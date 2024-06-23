import Vapor

func routes(_ app: Application) throws {
    
    let kujira = app.grouped("kujira")
    let users = app.grouped("users")
    
    // MARK: - GET
    
    // ~/kujira/get/string_variable
    kujira.get("get", "string", ":countryCode") { request async throws in
        guard let countryCode = request.parameters.get("countryCode", as: String.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(countryCode)\n\(request.parameters)"
    }
    
    // ~/kujira/get/integer_variable
    kujira.get("get", "integer", ":id") { request async throws in
        guard let id = request.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(id)"
    }
    
    // ~/kujira/get/models
    kujira.get("get", "models") { request async in
        return Model.mocks
    }
    
    // ~/kujira/get/model/query?sort=asc&search=taiwan
    kujira.get("get", "models", "query") { request async throws in
        let query = try request.query.decode(Query.self)
        return query
    }
    
    // ~/users/get/premium
    users.get("premium") { request async in
        return "Premium"
    }
    
    // MARK: - POST
    
    // ~/kujira/post/model
    kujira.post("post", "model") { request async throws in
        let model = try request.content.decode(Model.self)
        return model
    }
}
