//
//  LoginResponseDTO.swift
//  
//
//  Created by Wei-lun Su on 7/2/24.
//

import Foundation
import Vapor

struct LoginResponseDTO: Content {
    let error: Bool
    var reason: String? = nil
    let token: String?
    let userID: UUID
}
