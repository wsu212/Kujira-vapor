//
//  RecipeController.swift
//
//
//  Created by Wei-lun Su on 7/30/24.
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
        
        // POST: Save recipe
        // /api/users/:userId/recipes
        api.post("recipes", use: saveRecipe)
        
        // DELETE: Delete recipe
        // /api/users/:userId/recipes/:recipeId
        api.delete("recipes", ":recipeId", use: deleteRecipe)
        
        // GET: Fetch recipes
        // /api/users/:userId/recipes
        api.get("recipes", use: fetchRecipes)
    }
    
    @Sendable
    private func saveRecipe(req: Request) async throws -> RecipeResponseDTO {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let recipeRequestDTO = try req.content.decode(RecipeRequestDTO.self)
       
        let recipe = Recipe(
            title: recipeRequestDTO.title,
            image: recipeRequestDTO.image,
            readyInMinutes: recipeRequestDTO.readyInMinutes,
            servings: recipeRequestDTO.servings,
            sourceUrl: recipeRequestDTO.sourceUrl,
            summary: recipeRequestDTO.summary,
            isFavorite: recipeRequestDTO.isFavorite,
            extendedIngredients: recipeRequestDTO.extendedIngredients,
            analyzedInstructions: recipeRequestDTO.analyzedInstructions,
            userID: userId
        )
        
        // save the recipe to database
        try await recipe.save(on: req.db)
        
        // DTO for the response
        guard let responseDTO = RecipeResponseDTO(recipe) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
    }
    
    @Sendable
    private func deleteRecipe(req: Request) async throws -> RecipeResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the recipeId
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let recipe = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        try await recipe.delete(on: req.db)
        
        guard let responseDTO = RecipeResponseDTO(recipe) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
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
}
