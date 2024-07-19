//
//  CreateIngredientsTableMigration.swift
//
//
//  Created by Wei-lun Su on 7/19/24.
//

import Foundation
import Fluent

struct CreateIngredientsTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("ingredients")
            .id()
            .field("title", .string, .required)
            .field("image", .string, .required)
            .field("quantity", .int, .required)
            .field("recipe_id", .uuid, .required, .references("recipes", "id", onDelete: .cascade)) // foreign key
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("ingredients")
            .delete()
    }
}
