//
//  Model.swift
//  
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor

struct Model: Content {
    let id: Int
    let name: String
}

extension Model {
    static let mocks: [Self] = [
        .init(id: 0, name: "0"),
        .init(id: 1, name: "1"),
        .init(id: 2, name: "2"),
        .init(id: 3, name: "3"),
    ]
}
