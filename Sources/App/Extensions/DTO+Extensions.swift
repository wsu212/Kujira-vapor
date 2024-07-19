//
//  DTO+Extensions.swift
//
//
//  Created by Wei-lun Su on 7/4/24.
//

import DTO
import Vapor

extension LoginResponseDTO: Content {}
extension RegisterResponseDTO: Content {}
extension CategoryResponseDTO: Content {}

extension CategoryResponseDTO {
    init?(_ category: Category) {
        guard let id = category.id else {
            return nil
        }
        self.init(id: id, title: category.title, colorCode: category.colorCode)
    }
    
}

extension ItemResponseDTO: Content {}

extension ItemResponseDTO {
    init?(_ item: Item) {
        guard let id = item.id else {
            return nil
        }
        self.init(id: id, title: item.title, price: item.price, quantity: item.quantity)
    }
}

extension RecipeResponseDTO: Content {}

extension RecipeResponseDTO {
    init?(_ recipe: Recipe) {
        guard let id = recipe.id else {
            return nil
        }
        self.init(id: id, title: recipe.title, image: recipe.image)
    }
}

extension IngredientResponseDTO: Content {}

extension IngredientResponseDTO {
    init?(_ ingredient: Ingredient) {
        guard let id = ingredient.id else {
            return nil
        }
        self.init(id: id, title: ingredient.title, image: ingredient.image, quantity: ingredient.quantity)
    }
}
