//
//  CreateCategoriesTableMigration.swift
//
//
//  Created by Wei-lun Su on 7/7/24.
//

import Foundation
import Fluent

struct CreateCategoriesTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("categories")
            .id()
            .field("title", .string, .required)
            .field("color_code", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id")) // foreign key
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("categories")
            .delete()
    }
}
