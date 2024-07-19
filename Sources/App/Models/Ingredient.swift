//
//  Ingredient.swift
//
//
//  Created by Wei-lun Su on 7/19/24.
//

import Foundation
import Vapor
import Fluent

final class Ingredient: Model {
    static let schema = "ingredients"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "image")
    var image: String
    
    @Field(key: "quantity")
    var quantity: Int
    
    // foreign key
    @Parent(key: "recipe_id")
    var recipe: Recipe
    
    init() { }
    
    init(id: UUID? = nil, title: String, image: String, quantity: Int, recipeId: UUID) {
        self.id = id
        self.title = title
        self.image = image
        self.quantity = quantity
        self.$recipe.id = recipeId
    }
}
