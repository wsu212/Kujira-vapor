//
//  User.swift
//
//
//  Created by Wei-lun Su on 6/26/24.
//

import Foundation
import Fluent
import Vapor

final class User: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password")
    var password: String
    
    init() { }
    
    init(id: UUID? = nil, username: String, password: String) {
        self.id = id
        self.username = username
        self.password = password
    }
}

extension User: Content, Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(
            "username",
            as: String.self,
            is: !.empty,
            customFailureDescription: "Username cannot be empty."
        )
        validations.add(
            "password",
            as: String.self,
            is: .count(4...10),
            customFailureDescription: "Password must be between 4 and 10 characters long."
        )
    }
}
