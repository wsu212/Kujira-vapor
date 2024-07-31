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
        self.init(id: id, title: item.title, quantity: item.quantity, isChecked: item.isChecked)
    }
}

extension IngredientDTO {
    var ingredient: Ingredient {
        .init(aisle: self.aisle, consistency: self.consistency, name: self.name, original: self.original, originalName: self.originalName, amount: self.amount, unit: self.unit, meta: self.meta)
    }
}
