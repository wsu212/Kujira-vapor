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
    
    @Field(key: "aisle")
    var aisle: String
    
    @Field(key: "consistency")
    var consistency: String
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "original")
    var original: String
    
    @Field(key: "originalName")
    var originalName: String
    
    @Field(key: "amount")
    var amount: Double
    
    @Field(key: "unit")
    var unit: String
    
    @Field(key: "meta")
    var meta: [String]
    
    init() { }
    
    init(id: UUID? = nil, aisle: String, consistency: String, name: String, original: String, originalName: String, amount: Double, unit: String, meta: [String]) {
        self.id = id
        self.aisle = aisle
        self.consistency = consistency
        self.name = name
        self.original = original
        self.originalName = originalName
        self.amount = amount
        self.unit = unit
        self.meta = meta
    }
}
