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
