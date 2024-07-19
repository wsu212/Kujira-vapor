//
//  Recipe.swift
//
//
//  Created by Wei-lun Su on 7/19/24.
//

import Foundation
import Vapor
import Fluent

final class Recipe: Model {
    static let schema = "recipes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "image")
    var image: String
    
    // foreign key
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, title: String, image: String, userID: UUID) {
        self.id = id
        self.title = title
        self.image = image
        self.$user.id = userID
    }
}

extension Recipe: Content, Validatable {
    static func validations(_ validations: inout Validations) {
        // title cannot be empty
        validations.add(
            "title",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Title cannot be empty."
        )
        
        // color cannot be empty
        validations.add(
            "image",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Image cannot be empty."
        )
    }
}
