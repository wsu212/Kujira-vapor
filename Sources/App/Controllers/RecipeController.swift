//
//  RecipeController.swift
//
//
//  Created by Wei-lun Su on 7/18/24.
//

import Foundation
import Vapor
import DTO
import Fluent

final class RecipeController: RouteCollection, Sendable {
    func boot(routes: any RoutesBuilder) throws {
        // /api/users/:userId
        let api = routes.grouped("api", "users", ":userId")
            .grouped(JSONWebTokenAuthenticator())
        
        // POST: Save Recipe
        // /api/users/:userId/recipes
        api.post("recipes", use: saveRecipe)
        
        // GET: Fetch Recipes
        // /api/users/:userId/recipes
        api.get("recipes", use: fetchRecipes)
        
        // DELETE: Delete Recipe
        // /api/users/:userId/recipes/:recipeId
        api.delete("recipes", ":recipeId", use: deleteRecipe)
    }
    
    @Sendable
    private func saveRecipe(req: Request) async throws -> RecipeResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // DTO for the request
        let recipeRequestDTO = try req.content.decode(RecipeRequestDTO.self)
        
        let recipe = Recipe(
            title: recipeRequestDTO.title,
            image: recipeRequestDTO.image,
            userID: userId
        )
        
        // save the recipe to database
        try await recipe.save(on: req.db)
        
        // DTO for the response
        guard let id = recipe.id else {
            throw Abort(.internalServerError)
        }
        
        return .init(
            id: id,
            title: recipe.title,
            image: recipe.image
        )
    }
    
    @Sendable
    private func fetchRecipes(req: Request) async throws -> [RecipeResponseDTO] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let recipes = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .all()
            .compactMap(RecipeResponseDTO.init)
        
        return recipes
    }
    
    @Sendable func deleteRecipe(req: Request) async throws -> RecipeResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the recipeId
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // fine the recipe to delete
        guard let recipe = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // delete the recipe from database
        try await recipe.delete(on: req.db)
        
        // convert the deleted recipe to a response DTO
        guard let responseDTO = RecipeResponseDTO(recipe) else {
            throw Abort(.internalServerError)
        }
        
        // return the DTO to the client
        return responseDTO
    }
}
