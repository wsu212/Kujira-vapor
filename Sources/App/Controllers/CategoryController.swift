//
//  CategoryController.swift
//
//
//  Created by Wei-lun Su on 7/7/24.
//

import Foundation
import Vapor

final class CategoryController: RouteCollection, Sendable {
    func boot(routes: any RoutesBuilder) throws {
        // /api/users/:userId
        let api = routes.grouped("api", "users", ":userId")
        
        // POST: Saving Category
        // /api/users/:userId/categories
        api.post("categories", use: saveCategory)
    }
    
    @Sendable
    func saveCategory(req: Request) async throws -> String {
        // DTO for the request
        
        // DTO for the response
        
        return "OK"
    }
}
