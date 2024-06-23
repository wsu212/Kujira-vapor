//
//  AuthenticationMiddleware.swift
//
//
//  Created by Wei-lun Su on 6/23/24.
//

import Foundation
import Vapor

struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        guard let authentication = request.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        print("token: \(authentication.token)")
        return try await next.respond(to: request)
    }
}
