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
        // /api/register
        api.post("register", use: register)
        
        // /api/login
        api.post("login", use: login)
    }
    
    @Sendable
    func login(req: Request) async throws -> LoginResponseDTO {
        // decode the request
        let user = try req.content.decode(User.self)
        
        // check if the user exists in the database
        guard let existingUser = try await User.query(on: req.db)
            .filter(\.$username == user.username)
            .first() else {
                throw Abort(.badRequest)
            }
        
        // validate the password
        let isVerified = try await req.password
            .async
            .verify(
                user.password,
                created: existingUser.password
            )
        
        if !isVerified {
            throw Abort(.unauthorized)
        }
        
        // generate the token and return it to the user
        let authPayload = try AuthPayload(
            expiration: .init(value: .distantFuture),
            userID: existingUser.requireID()
        )
        
        return try .init(
            error: false,
            token: req.jwt.sign(authPayload),
            userID: existingUser.requireID()
        )
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
