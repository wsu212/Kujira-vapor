//
//  DTO+Extensions.swift
//
//
//  Created by Wei-lun Su on 7/4/24.
//

import DTO
import Vapor

extension LoginResponseDTO: Content {}
extension RegisterResponseDTO: Content {}
extension CategoryResponseDTO: Content {}

extension CategoryResponseDTO {
    init?(_ category: Category) {
        guard let id = category.id else {
            return nil
        }
        self.init(id: id, title: category.title, colorCode: category.colorCode)
    }
    
}
