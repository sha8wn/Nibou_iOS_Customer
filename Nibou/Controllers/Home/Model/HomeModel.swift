

import Foundation
import UIKit


struct HomeModel : Codable {
    var data : [HomeData]?

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([HomeData].self, forKey: .data)
    }
}

struct HomeData : Codable {
    let id : String?
    let type : String?
    let attributes : HomeAttributes?
    var newMessageCount: Int?
    var lastMessageTimestamp: String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case type = "type"
        case attributes = "attributes"
        case newMessageCount = "newMessageCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(HomeAttributes.self, forKey: .attributes)
        newMessageCount = try values.decodeIfPresent(Int.self, forKey: .newMessageCount)
    }
}

struct HomeAttributes : Codable {
    let users : [ExpertProfileModel]?
    let expertises : [HomeExpertises]?
    let last_message : LastMessage?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {

        case users = "users"
        case expertises = "expertises"
        case last_message = "last_message"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        users = try values.decodeIfPresent([ExpertProfileModel].self, forKey: .users)
        expertises = try values.decodeIfPresent([HomeExpertises].self, forKey: .expertises)
        last_message = try values.decodeIfPresent(LastMessage.self, forKey: .last_message)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
}

struct LastMessage : Codable{
    let data : LastMessageData?
  
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(LastMessageData.self, forKey: .data)

    }
}

struct LastMessageData : Codable {
    let id : String?
    let type : String?
    let attributes : ChatHistoryAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ChatHistoryAttributes.self, forKey: .attributes)
    }
}



struct HomeUsers : Codable {
    let data : HomeUserData?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(HomeUserData.self, forKey: .data)
    }
}

struct HomeUserData : Codable {
    let id : String?
    let type : String?
    let attributes : HomeUserAttributes?
//    let relationships : HomeUserRelationships?

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
        attributes = try values.decodeIfPresent(HomeUserAttributes.self, forKey: .attributes)
//        relationships = try values.decodeIfPresent(HomeUserRelationships.self, forKey: .relationships)
    }
}

struct HomeUserAttributes : Codable {
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
    }

}

struct HomeUserRelationships : Codable {
    let languages : UserLanguages?
//    let expertises : HomeExpertises?
    let user_credit_cards : User_credit_cards?
    let reviews : ProfileReviews?

    enum CodingKeys: String, CodingKey {

        case languages = "languages"
//        case expertises = "expertises"
        case user_credit_cards = "user_credit_cards"
        case reviews = "reviews"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        languages = try values.decodeIfPresent(UserLanguages.self, forKey: .languages)
//        expertises = try values.decodeIfPresent(HomeExpertises.self, forKey: .expertises)
        user_credit_cards = try values.decodeIfPresent(User_credit_cards.self, forKey: .user_credit_cards)
        reviews = try values.decodeIfPresent(ProfileReviews.self, forKey: .reviews)
    }

}

struct HomeExpertises : Codable {
    let data : ExpertisesData?

    enum CodingKeys: String, CodingKey {

        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(ExpertisesData.self, forKey: .data)
    }

}

struct ExpertisesData : Codable {
    let id : String?
    let type : String?
    let attributes : ExpertisesAttributes?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(ExpertisesAttributes.self, forKey: .attributes)
    }

}

struct ExpertisesAttributes : Codable {
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
