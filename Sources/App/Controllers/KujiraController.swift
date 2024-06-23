//
//  KujiraController.swift
//
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor

struct KujiraController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let kujira = routes.grouped("kujira")
        kujira.get(use: index)
        kujira.get(":id", use: show)
    }
    
    @Sendable
    func index(req: Request) async throws -> String {
        return "Index"
    }
    
    @Sendable
    func show(req: Request) async throws -> String {
        guard let id = req.parameters.get("id") else {
            throw Abort(.internalServerError)
        }
        return "The ID: \(id)"
    }
}
