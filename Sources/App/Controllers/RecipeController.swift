//
//  RecipeController.swift
//
//
//  Created by Wei-lun Su on 7/30/24.
//

import Foundation
import Vapor
import DTO

final class RecipeController: RouteCollection, Sendable {
    func boot(routes: any RoutesBuilder) throws {
        // /api/users/:userId
        let api = routes.grouped("api", "users", ":userId")
            .grouped(JSONWebTokenAuthenticator())
        
        // POST: Save recipe
        // /api/users/:userId/recipes
        api.post("recipes", use: saveRecipe)
    }
    
    @Sendable
    private func saveRecipe(req: Request) async throws -> String {
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
            extendedIngredients: recipeRequestDTO.extendedIngredients,
            userID: userId
        )
        
        // save the recipe to database
        try await recipe.save(on: req.db)
        
        // DTO for the response
        guard let id = recipe.id else {
            throw Abort(.internalServerError)
        }
        
        print("#### \(id)")
        
        return "saveRecipe is called...."
    }
}
