//
//  CardListModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 08/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct CardListModel : Codable {
    var included : [CardIncluded]?
    
    enum CodingKeys: String, CodingKey {
        
        case included = "included"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        included = try values.decodeIfPresent([CardIncluded].self, forKey: .included)
    }
    
}

struct CardIncluded : Codable {
    let id : String?
    let type : String?
    var attributes : CardAttributes?
    var isSelected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(CardAttributes.self, forKey: .attributes)
    }
    
}

struct CardAttributes : Codable {
    let card_type : String?
    let last_numbers : String?
    let exp_date : String?
    var is_default : Bool?
    var is_active : Bool?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case card_type = "card_type"
        case last_numbers = "last_numbers"
        case exp_date = "exp_date"
        case is_default = "is_default"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case is_active = "is_active"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        card_type = try values.decodeIfPresent(String.self, forKey: .card_type)
        last_numbers = try values.decodeIfPresent(String.self, forKey: .last_numbers)
        exp_date = try values.decodeIfPresent(String.self, forKey: .exp_date)
        is_default = try values.decodeIfPresent(Bool.self, forKey: .is_default)
        is_active = try values.decode(Bool.self, forKey: .is_active)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
}
