//
//  RegisterResponseDTO.swift
//
//
//  Created by Wei-lun Su on 6/26/24.
//

import Foundation
import Vapor

struct RegisterResponseDTO: Content {
    let error: Bool
    var reason: String? = nil
}
