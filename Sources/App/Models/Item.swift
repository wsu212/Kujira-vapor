//
//  Item.swift
//  
//
//  Created by Wei-lun Su on 7/9/24.
//

import Foundation
import Vapor
import Fluent

final class Item: Model {
    static let schema = "items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "quantity")
    var quantity: Int
    
    @Field(key: "isChecked")
    var isChecked: Bool
    
    // foreign key
    @Parent(key: "category_id")
    var category: Category
    
    init() { }
    
    init(id: UUID? = nil, title: String, quantity: Int, isChecked: Bool, categoryId: UUID) {
        self.id = id
        self.title = title
        self.quantity = quantity
        self.isChecked = isChecked
        self.$category.id = categoryId
    }
}
