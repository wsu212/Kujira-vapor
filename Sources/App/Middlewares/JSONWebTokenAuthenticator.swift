//
//  JSONWebTokenAuthenticator.swift
//
//
//  Created by Wei-lun Su on 7/13/24.
//

import Foundation
import Vapor

struct JSONWebTokenAuthenticator: AsyncRequestAuthenticator {
    func authenticate(request: Request) async throws {
        try request.jwt.verify(as: AuthPayload.self)
    }
}
