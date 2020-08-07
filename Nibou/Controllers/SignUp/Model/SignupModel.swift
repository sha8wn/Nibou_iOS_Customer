//
//  SignupModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 27/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

// MARK: - SignupModel
struct SignupModel: Codable {
    let data            : SignupDataClass
}

// MARK: - DataClass
struct SignupDataClass: Codable {
    let id, type        : String
    let attributes      : SignupAttributes
}

// MARK: - Attributes
struct SignupAttributes: Codable {
    let username        : String
    let accountType     : Int
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case accountType    = "account_type"
        case createdAt      = "created_at"
        case updatedAt      = "updated_at"
    }
}
