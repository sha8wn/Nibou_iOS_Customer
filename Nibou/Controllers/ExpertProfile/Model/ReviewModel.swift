//
//  ReviewModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 25/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct Reviews{
    var name: String?
    var date: String?
    var rate: Int?
    var desc: String?
    var senderId: String?
}

struct Timings{
    var day: String?
    var time: String?
}


struct ReviewModel : Codable {
    let data : [ReviewData]?
    let included : [ProfileData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case included = "included"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ReviewData].self, forKey: .data)
        included = try values.decodeIfPresent([ProfileData].self, forKey: .included)
    }
    
}

struct ReviewData : Codable {
    let id : String?
    let type : String?
    let attributes : ReviewAttributes?
    let relationships : ReviewRelationships?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
        case relationships = "relationships"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ReviewAttributes.self, forKey: .attributes)
        relationships = try values.decodeIfPresent(ReviewRelationships.self, forKey: .relationships)
    }
    
}

struct ReviewAttributes : Codable {
    let value : Int?
    let comment : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case value = "value"
        case comment = "comment"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decodeIfPresent(Int.self, forKey: .value)
        comment = try values.decodeIfPresent(String.self, forKey: .comment)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}


struct ReviewRelationships : Codable {
    let customer : ReviewCustomer?
    let expert : ReviewExpert?
    
    enum CodingKeys: String, CodingKey {
        
        case customer = "customer"
        case expert = "expert"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer = try values.decodeIfPresent(ReviewCustomer.self, forKey: .customer)
        expert = try values.decodeIfPresent(ReviewExpert.self, forKey: .expert)
    }
    
}

struct ReviewCustomer : Codable {
    let data : ReviewUserData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ReviewUserData.self, forKey: .data)
    }
    
}

struct ReviewExpert : Codable {
    let data : ReviewUserData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ReviewUserData.self, forKey: .data)
    }
    
}

struct ReviewUserData : Codable {
    let id : String?
    let type : String?

    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
    
}
