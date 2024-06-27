//
//  UserController.swift
//
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor
import Fluent

final class UserController: RouteCollection, Sendable {
    func boot(routes: any RoutesBuilder) throws {
        let api = routes.grouped("api")
        api.post("register", use: register)
    }
    
    @Sendable
    func register(req: Request) async throws -> RegisterResponseDTO {
        // validate the user
        try User.validate(content: req)
        
        let user = try req.content.decode(User.self)
        
        // find if the user already exists using the username
        if let _ = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() {
            throw Abort(.conflict, reason: "Username is already taken.")
        }
        
        // hash the password
        user.password = try await req.password.async.hash(user.password)
        
        // save the user to database
        try await user.save(on: req.db)
        
        return .init(error: false)
    }
}
