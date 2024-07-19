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
        
        // POST: Save Ingredient
        // /api/users/:userId/recipes/:recipeId/ingredients
        api.post("recipes", ":recipeId", "ingredients", use: saveIngredient)

        // GET: Fetch Ingredients
        // /api/users/:userId/recipes/:ingredients/ingredients
        api.get("recipes", ":recipeId", "ingredients", use: fetchIngredientsByRecipe)

        // DELETE: Delete Ingredient
        // /api/users/:userId/recipes/:recipeId/ingredients/:ingredientId
        api.delete("recipes", ":recipeId", "ingredients", ":ingredientId", use: deleteIngredient)
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
    
    @Sendable
    private func saveIngredient(req: Request) async throws -> IngredientResponseDTO {
        // get the userId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // get the recipeId
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // find the user
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        // find the recipe
        guard let _ = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // decode IngredientRequestDTO
        let requestDTO = try req.content.decode(IngredientRequestDTO.self)
        
        // convert to Ingredient
        let ingredient = Ingredient(
            title: requestDTO.title,
            image: requestDTO.image,
            quantity: requestDTO.quantity,
            recipeId: recipeId
        )
        
        // save the ingredient to database
        try await ingredient.save(on: req.db)
        
        // DTO for the response
        guard let responseDTO = IngredientResponseDTO(ingredient) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
    }
    
    @Sendable
    private func fetchIngredientsByRecipe(req: Request) async throws -> [IngredientResponseDTO] {
        // get the userId and recipeId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // validate the userId
        guard let _ = try await User.find(userId, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // find the recipe
        guard let _ = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // get ingredients by recipeId
        let ingredients = try await Ingredient.query(on: req.db)
            .filter(\.$recipe.$id == recipeId)
            .all()
            .compactMap(IngredientResponseDTO.init)
        
        return ingredients
    }
    
    @Sendable
    private func deleteIngredient(req: Request) async throws -> IngredientResponseDTO {
        // get the userId, recipeId, and ingredientId
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let recipeId = req.parameters.get("recipeId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let ingredientId = req.parameters.get("ingredientId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        // find the recipe
        guard let _ = try await Recipe.query(on: req.db)
            .filter(\.$user.$id == userId)
            .filter(\.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // find the ingredient
        guard let ingredient = try await Ingredient.query(on: req.db)
            .filter(\.$id == ingredientId)
            .filter(\.$recipe.$id == recipeId)
            .first() else { throw Abort(.notFound) }
        
        // delete the ingredient from database
        try await ingredient.delete(on: req.db)
        
        guard let responseDTO = IngredientResponseDTO(ingredient) else {
            throw Abort(.internalServerError)
        }
        
        return responseDTO
    }
}
