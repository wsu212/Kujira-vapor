import Vapor

func routes(_ app: Application) throws {
    // http://127.0.0.1:8080
    app.get { request async in
        "\(request.parameters)"
    }
    
    // http://127.0.0.1:8080/kujira/string_variable
    app.get("kujira", "string", ":countryCode") { request async throws in
        guard let countryCode = request.parameters.get("countryCode", as: String.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(countryCode)\n\(request.parameters)"
    }
    
    // http://127.0.0.1:8080/kujira/integer_variable
    app.get("kujira", "integer", ":id") { request async throws in
        guard let id = request.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "kujira: \(id)"
    }
    
    // http://127.0.0.1:8080/kujira/models
    app.get("kujira", "models") { request async in
        return Model.mocks
    }
}
