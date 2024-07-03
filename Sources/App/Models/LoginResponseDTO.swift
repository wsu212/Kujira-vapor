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
    var token: String? = nil
    var userID: UUID? = nil
}
