//
//  Category.swift
//
//
//  Created by Wei-lun Su on 7/7/24.
//

import Foundation
import Vapor
import Fluent

final class Category: Model {
    static let schema = "categories"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "color_code")
    var colorCode: String
    
    // foreign key
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = nil, title: String, colorCode: String, userID: UUID) {
        self.id = id
        self.title = title
        self.colorCode = colorCode
        self.$user.id = userID
    }
}

extension Category: Content, Validatable {
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
            "colorCode",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Color code cannot be empty."
        )
    }
}
