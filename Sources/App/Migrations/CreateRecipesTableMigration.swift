//
//  CreateRecipesTableMigration.swift
//
//
//  Created by Wei-lun Su on 7/18/24.
//

import Foundation
import Fluent

struct CreateRecipesTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("recipes")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id")) // foreign key
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("recipes")
            .delete()
    }
}

struct CreateRecipesTableMigration_v2: AsyncMigration {
    func prepare(on database: any Database) async throws {
        // Add new columns
        try await database.schema("recipes")
            .field("readyInMinutes", .int, .required, .custom("DEFAULT 0"))
            .field("servings", .int, .required, .custom("DEFAULT 0"))
            .field("sourceUrl", .string, .required, .custom("DEFAULT ''"))
            .field("summary", .string, .required, .custom("DEFAULT ''"))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        // Delete new columns
        try await database.schema("recipes")
            .deleteField("readyInMinutes")
            .deleteField("servings")
            .deleteField("sourceUrl")
            .deleteField("summary")
            .update()
    }
}

struct CreateRecipesTableMigration_v3: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("recipes")
            .field("extendedIngredients", .array(of: .json))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("recipes")
            .deleteField("extendedIngredients")
            .update()
    }
}

struct CreateRecipesTableMigration_v4: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("recipes")
            .field("analyzedInstructions", .array(of: .json))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("recipes")
            .deleteField("analyzedInstructions")
            .update()
    }
}
