//
//  AddIsCheckedItemsTableMigration.swift
//
//
//  Created by Wei-lun Su on 7/27/24.
//

import Foundation
import Fluent

struct AddIsCheckedItemsTableMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("items")
            .deleteField("price")
            .field("isChecked", .bool, .required)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("items")
            .deleteField("price")
            .field("price", .double, .required)
            .update()
    }
}
