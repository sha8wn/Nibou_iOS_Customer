//
//  ChatHistoryModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation


struct ChatHistoryModel : Codable {
    
    let data : [ChatHistoryData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ChatHistoryData].self, forKey: .data)
    }
    
}

struct ChatHistoryData : Codable {
    let id : String?
    let type : String?
    let attributes : ChatHistoryAttributes?
//    let relationships : ChatHistoryRelationships?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
//        case relationships = "relationships"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ChatHistoryAttributes.self, forKey: .attributes)
//        relationships = try values.decodeIfPresent(ChatHistoryRelationships.self, forKey: .relationships)
    }
    
}

struct ChatHistoryAttributes : Codable {
    let text : String?
    let images : [ChatHistoryImages]?
    let from_user_id : Int?
    let to_user_id : Int?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case text = "text"
        case images = "images"
        case from_user_id = "from_user_id"
        case to_user_id = "to_user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        images = try values.decodeIfPresent([ChatHistoryImages].self, forKey: .images)
        from_user_id = try values.decodeIfPresent(Int.self, forKey: .from_user_id)
        to_user_id = try values.decodeIfPresent(Int.self, forKey: .to_user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}

struct ChatHistoryRelationships : Codable {
    let room : ChatHistoryRoom?
    
    enum CodingKeys: String, CodingKey {
        
        case room = "room"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        room = try values.decodeIfPresent(ChatHistoryRoom.self, forKey: .room)
    }
    
}

struct ChatHistoryRoom : Codable {
    let data : ChatHistoryData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ChatHistoryData.self, forKey: .data)
    }
    
}

struct ChatHistoryImages : Codable {
    let data : ChatHistoryImageData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ChatHistoryImageData.self, forKey: .data)
    }
    
}

struct ChatHistoryImageData : Codable {
    let id : String?
    let type : String?
    let attributes : ChatHistoryImageAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ChatHistoryImageAttributes.self, forKey: .attributes)
    }
    
}

struct ChatHistoryImageAttributes : Codable {
    let images : [ChatHistorySubimages]?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case images = "images"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        images = try values.decodeIfPresent([ChatHistorySubimages].self, forKey: .images)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}

struct ChatHistorySubimages : Codable {
    let url : String?
    let w220 : W220?
    
    enum CodingKeys: String, CodingKey {
        
        case url = "url"
        case w220 = "w220"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        w220 = try values.decodeIfPresent(W220.self, forKey: .w220)
    }
    
}


struct ChatSendModel : Codable {
    
    let data : ChatHistoryData?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ChatHistoryData.self, forKey: .data)
    }
    
}
