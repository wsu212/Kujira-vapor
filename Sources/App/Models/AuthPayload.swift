//
//  AuthPayload.swift
//
//
//  Created by Wei-lun Su on 7/2/24.
//

import Foundation
import JWT

struct AuthPayload: JWTPayload {
    //typealias Payload = AuthPayload
    
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case userID = "uid"
    }
    
    let expiration: ExpirationClaim
    let userID: UUID
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
