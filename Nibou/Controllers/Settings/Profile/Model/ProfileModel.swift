//
//  ProfileModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 28/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct ProfileModel : Codable {
    let data : ProfileData?
//    let included: [IncludedData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
//        case included = "included"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ProfileData.self, forKey: .data)
//        included = try values.decodeIfPresent([IncludedData].self, forKey: .included)
    }
    
}

struct IncludedData : Codable {
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

struct ProfileData : Codable {
    let id : String?
    let type : String?
    let attributes : UserAttributes?
//    let relationships : UserRelationships?
    
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
        attributes = try values.decodeIfPresent(UserAttributes.self, forKey: .attributes)
//        relationships = try values.decodeIfPresent(UserRelationships.self, forKey: .relationships)
    }
    
}


struct UserAttributes : Codable {
    let country : String?
    let username : String?
    let gender : String?
    let short_bio : String?
    let account_type : Int?
    let timezone : String?
    let nationality : String?
    let dob : String?
    let avatar : UserAvatar?
    let created_at : String?
    let updated_at : String?
    let email : String?
    let name : String?
    
    enum CodingKeys: String, CodingKey {
        
        case country = "country"
        case username = "username"
        case gender = "gender"
        case short_bio = "short_bio"
        case account_type = "account_type"
        case timezone = "timezone"
        case nationality = "nationality"
        case dob = "dob"
        case avatar = "avatar"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case email = "email"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        gender = try? values.decodeIfPresent(String.self, forKey: .gender)
        short_bio = try values.decodeIfPresent(String.self, forKey: .short_bio)
        account_type = try values.decodeIfPresent(Int.self, forKey: .account_type)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        nationality = try values.decodeIfPresent(String.self, forKey: .nationality)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        avatar = try values.decodeIfPresent(UserAvatar.self, forKey: .avatar)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }
}

struct UserRelationships : Codable {
    let languages : UserLanguages?
    let expertises : UserExpertises?
    
    enum CodingKeys: String, CodingKey {
        
        case languages = "languages"
        case expertises = "expertises"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languages = try values.decodeIfPresent(UserLanguages.self, forKey: .languages)
        expertises = try values.decodeIfPresent(UserExpertises.self, forKey: .expertises)
    }
    
}

struct UserAvatar : Codable {
    let url : String?
    let w220 : W220?
    let w50 : W50?
    
    enum CodingKeys: String, CodingKey {
        
        case url = "url"
        case w220 = "w220"
        case w50 = "w50"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        w220 = try values.decodeIfPresent(W220.self, forKey: .w220)
        w50 = try values.decodeIfPresent(W50.self, forKey: .w50)
    }
    
}



struct UserLanguages : Codable {
    let data : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }
    
}


struct UserExpertises : Codable {
    let data : [String]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }
    
}



struct W50 : Codable {
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
}

struct W220 : Codable {
    let url : String?
    
    enum CodingKeys: String, CodingKey {
        
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
    
}
