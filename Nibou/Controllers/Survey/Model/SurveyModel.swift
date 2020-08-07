//
//  SurveyModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 06/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct SurveyModel : Codable {
    let data : [SurveyData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([SurveyData].self, forKey: .data)
    }
    
}

struct SurveyData : Codable {
    let id : String?
    let type : String?
    let attributes : SurveyAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(SurveyAttributes.self, forKey: .attributes)
    }
    
}

struct SurveyAttributes : Codable {
    let active : Bool?
    let title : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case active = "active"
        case title = "title"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        active = try values.decodeIfPresent(Bool.self, forKey: .active)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}


struct AddSurveyModel : Codable {
    let data : SurveyData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(SurveyData.self, forKey: .data)
    }
    
}
