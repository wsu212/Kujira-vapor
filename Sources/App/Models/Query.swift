//
//  Query.swift
//
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor

struct Query: Content {
    let sort: String?
    let search: String?
}
