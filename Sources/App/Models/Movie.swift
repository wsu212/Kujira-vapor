//
//  Movie.swift
//  
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor

struct Movie: Content {
    let id: Int
    let title: String
}

extension Movie {
    static let mocks: [Self] = [
        .init(id: 0, title: "0"),
        .init(id: 1, title: "1"),
        .init(id: 2, title: "2"),
        .init(id: 3, title: "3"),
    ]
}
