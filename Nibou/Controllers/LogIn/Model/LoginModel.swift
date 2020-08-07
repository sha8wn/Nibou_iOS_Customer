//
//  LoginModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 24/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

// MARK: - LoginModel
struct LoginModel: Codable {
    let accessToken, tokenType  : String
    let expiresIn               : Int
    let refreshToken            : String
    let createdAt               : Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken        = "access_token"
        case tokenType          = "token_type"
        case expiresIn          = "expires_in"
        case refreshToken       = "refresh_token"
        case createdAt          = "created_at"
    }
}
