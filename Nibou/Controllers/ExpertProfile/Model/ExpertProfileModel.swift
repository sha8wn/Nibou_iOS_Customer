//
//  ExpertProfileModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 10/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//


import Foundation

struct PreviousExpertProfileModel : Codable {
    let data : [ExpertProfileData]?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([ExpertProfileData].self, forKey: .data)
    }
    
}

struct ExpertProfileModel : Codable {
    let data : ExpertProfileData?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ExpertProfileData.self, forKey: .data)
    }

}

struct ExpertProfileData : Codable {
    let id : String?
    let type : String?
    let attributes : ExpertProfileAttributes?
//    let relationships : ExpertProfileRelationships?

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
        attributes = try values.decodeIfPresent(ExpertProfileAttributes.self, forKey: .attributes)
//        relationships = try values.decodeIfPresent(ExpertProfileRelationships.self, forKey: .relationships)
    }

}

struct ExpertProfileAttributes : Codable {
    let country : String?
    let username : String?
    let gender : String?
    let short_bio : String?
    let account_type : Int?
    let timezone : String?
    let nationality : String?
    let dob : String?
    let avatar : UserAvatar?
    let city : String?
    let pdf : ExpertProfilePdf?
    let created_at : String?
    let updated_at : String?
    let name : String?
    let online : Bool?
    let available: Bool?

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
        case city = "city"
        case pdf = "pdf"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case name = "name"
        case online = "online"
        case available = "available"
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
        city = try values.decodeIfPresent(String.self, forKey: .city)
        pdf = try values.decodeIfPresent(ExpertProfilePdf.self, forKey: .pdf)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        online = try? values.decodeIfPresent(Bool.self, forKey: .online)
        available = try? values.decodeIfPresent(Bool.self, forKey: .available)
    }

}
struct ExpertProfileRelationships : Codable {
    let languages : UserLanguages?
    let expertises : UserExpertises?
    let user_credit_cards : User_credit_cards?
    let reviews : ProfileReviews?

    enum CodingKeys: String, CodingKey {

        case languages = "languages"
        case expertises = "expertises"
        case user_credit_cards = "user_credit_cards"
        case reviews = "reviews"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languages = try values.decodeIfPresent(UserLanguages.self, forKey: .languages)
        expertises = try values.decodeIfPresent(UserExpertises.self, forKey: .expertises)
        user_credit_cards = try values.decodeIfPresent(User_credit_cards.self, forKey: .user_credit_cards)
        reviews = try values.decodeIfPresent(ProfileReviews.self, forKey: .reviews)
    }

}

struct ExpertProfilePdf : Codable {
    let url : String?

    enum CodingKeys: String, CodingKey {

        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

struct ProfileReviews : Codable {
    let data : [String]?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}

struct User_credit_cards : Codable {
    let data : [String]?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}


