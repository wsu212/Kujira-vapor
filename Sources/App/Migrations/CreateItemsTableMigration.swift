//
//  CreateItemsTableMigration.swift
//  
//
//  Created by Wei-lun Su on 7/9/24.
//

import Foundation
import Fluent

struct CreateItemsTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("items")
            .id()
            .field("title", .string, .required)
            .field("price", .double, .required)
            .field("quantity", .int, .required)
            .field("category_id", .uuid, .required, .references("categories", "id", onDelete: .cascade)) // foreign key
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("items")
            .delete()
    }
}
