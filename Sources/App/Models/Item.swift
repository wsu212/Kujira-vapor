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
    
    @Field(key: "price")
    var price: Double
    
    @Field(key: "quantity")
    var quantity: Int
    
    // foreign key
    @Parent(key: "category_id")
    var category: Category
    
    init() { }
    
    init(id: UUID? = nil, title: String, price: Double, quantity: Int, categoryId: UUID) {
        self.id = id
        self.title = title
        self.price = price
        self.quantity = quantity
        self.$category.id = categoryId
    }
}
