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
        
        // PUT: Update recipe
        // /api/users/:userId/recipes/:recipeId
        api.put("recipes", ":recipeId", use: updateRecipe)
        
        // DELETE: Delete recipe
        // /api/users/:userId/recipes/:recipeId
        api.delete("recipes", ":recipeId", use: deleteRecipe)
        
        // GET: Fetch recipes
        // /api/users/:userId/recipes
        api.get("recipes", use: fetchRecipes)
    }
    
    @Sendable
    private func saveRecipe(req: Request) async throws -> [RecipeResponseDTO] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        let dtos = try req.content.decode([RecipeRequestDTO].self)
        var responseDTOs: [RecipeResponseDTO] = []
        
        for dto in dtos {
            let recipe = Recipe(
                title: dto.title,
                image: dto.image,
                readyInMinutes: dto.readyInMinutes,
                servings: dto.servings,
                sourceUrl: dto.sourceUrl,
                summary: dto.summary,
                isFavorite: dto.isFavorite,
                diets: dto.diets,
                dishTypes: dto.dishTypes,
                extendedIngredients: dto.extendedIngredients,
                analyzedInstructions: dto.analyzedInstructions,
                userID: userId
            )
            
            // save the recipe to database
            try await recipe.save(on: req.db)
            
            // DTO for the response
            guard let responseDTO = RecipeResponseDTO(recipe) else {
                throw Abort(.internalServerError)
            }
            responseDTOs.append(responseDTO)
        }
        
        return responseDTOs
    }
    
    @Sendable
    private func updateRecipe(req: Request) async throws -> RecipeResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the recipeId
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // make sure the recipe exists and belongs to a user
        guard let recipe = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // decode RecipeRequestDTO
        let recipeRequestDTO = try req.content.decode(RecipeRequestDTO.self)
        
        // update the recipe
        recipe.isFavorite = recipeRequestDTO.isFavorite
        
        try await recipe.update(on: req.db)
        
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
