//
//  CategoryController.swift
//
//
//  Created by Wei-lun Su on 7/7/24.
//

import Foundation
import Vapor
import DTO
import Fluent

final class CategoryController: RouteCollection, Sendable {
    func boot(routes: any RoutesBuilder) throws {
        // /api/users/:userId
        let api = routes.grouped("api", "users", ":userId")
        
        // POST: Saving Category
        // /api/users/:userId/categories
        api.post("categories", use: saveCategory)
        
        // GET: Fetching Categories
        // /api/users/:userId/categories
        api.get("categories", use: fetchCategories)
    }
    
    @Sendable
    func saveCategory(req: Request) async throws -> CategoryResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // DTO for the request
        let categoryRequestDTO = try req.content.decode(CategoryRequestDTO.self)
        
        let category = Category(
            title: categoryRequestDTO.title,
            colorCode: categoryRequestDTO.colorCode,
            userID: userId
        )
        
        // save the category to database
        try await category.save(on: req.db)
        
        // DTO for the response
        guard let id = category.id else {
            throw Abort(.internalServerError)
        }
        
        return .init(
            id: id,
            title: category.title,
            colorCode: category.colorCode
        )
    }
    
    @Sendable
    func fetchCategories(req: Request) async throws -> [CategoryResponseDTO] {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // get categories by userId
        let categories = try await Category.query(on: req.db)
            .filter(\.$user.$id == userId)
            .all()
            .compactMap(CategoryResponseDTO.init)
        
        return categories
    }
}
