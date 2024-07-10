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
        
        // DELETE: Delete Category
        // /api/users/:userId/categories/:categoryId
        api.delete("categories", ":categoryId", use: deleteCategory)
        
        // POST: Saving Item
        // /api/users/:userId/categories/:categoryId/items
        api.post("categories", ":categoryId", "items", use: saveItem)
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
    
    @Sendable
    func deleteCategory(req: Request) async throws -> CategoryResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the categoryId
        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let category = try await Category.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == categoryId)
            .first() else { throw Abort(.notFound) }
        
        try await category.delete(on: req.db)
        
        guard let responseDTO = CategoryResponseDTO(category) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
    }
    
    @Sendable
    func saveItem(req: Request) async throws -> ItemResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the categoryId
        guard let categoryId = req.parameters.get("categoryId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // find the user
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        // find the category
        guard let _ = try await Category.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == categoryId)
            .first() else { throw Abort(.notFound) }
        
        // decode ItemRequestDTO
        let itemRequestDTO = try req.content.decode(ItemRequestDTO.self)
        
        // convert to Item
        let item = Item(
            title: itemRequestDTO.title,
            price: itemRequestDTO.price,
            quantity: itemRequestDTO.quantity,
            categoryId: categoryId
        )
        
        // save the item to database
        try await item.save(on: req.db)
        
        // DTO for the response
        guard let responseDTO = ItemResponseDTO(item) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
    }
}
