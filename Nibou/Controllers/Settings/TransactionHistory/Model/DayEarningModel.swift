//
//  DayEarningModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 14/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

struct DayEarningModel : Codable {
    let data : [DayEarningData]?
    let meta : DayEarningMeta?
    
    enum CodingKeys: String, CodingKey {
        
        case data = "data"
        case meta = "meta"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([DayEarningData].self, forKey: .data)
        meta = try values.decodeIfPresent(DayEarningMeta.self, forKey: .meta)
    }
    
}

struct DayEarningData : Codable {
    let id : String?
    let type : String?
    let attributes : DayEarningAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(DayEarningAttributes.self, forKey: .attributes)
        
    }
    
}

struct DayEarningAttributes : Codable {
    let total_seconds : Double?
    let payed : Bool?
    let amount : Double?
    let room_id : String?
    let room : CopyChatModel?
    let created_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case total_seconds = "total_seconds"
        case payed = "payed"
        case amount = "amount"
        case room_id = "room_id"
        case room = "room"
        case created_at = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_seconds = try values.decodeIfPresent(Double.self, forKey: .total_seconds)
        payed = try values.decodeIfPresent(Bool.self, forKey: .payed)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        room_id = try values.decodeIfPresent(String.self, forKey: .room_id)
        room = try values.decodeIfPresent(CopyChatModel.self, forKey: .room)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
    }
    
}

struct DayEarningMeta : Codable {
//    let current_page : Int?
//    let next_page : Int?
//    let prev_page : String?
//    let total_pages : Int?
    let total_count : Int?
//
    enum CodingKeys: String, CodingKey {
//        case current_page = "current_page"
//        case next_page = "next_page"
//        case prev_page = "prev_page"
//        case total_pages = "total_pages"
        case total_count = "total_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
//        next_page = try values.decodeIfPresent(Int.self, forKey: .next_page)
//        prev_page = try values.decodeIfPresent(String.self, forKey: .prev_page)
//        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
    }
    
}

struct EarningMonthModel : Codable {
    let data : [PaymentOverallData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([PaymentOverallData].self, forKey: .data)
    }
}

struct DashboardOverallModel : Codable {
    let data : PaymentOverallData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(PaymentOverallData.self, forKey: .data)
    }
}

struct PaymentOverallData : Codable {
    let type : String?
    let attributes : PaymentOverallAttributes?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case attributes = "attributes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        attributes = try values.decodeIfPresent(PaymentOverallAttributes.self, forKey: .attributes)
    }
    
}

struct PaymentOverallAttributes : Codable {
    let total_seconds : Double?
    let date_at: String?
    let amount : Double?
    
    enum CodingKeys: String, CodingKey {
        
        case total_seconds = "total_seconds"
        case amount = "amount"
        case date_at = "date_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_seconds = try values.decodeIfPresent(Double.self, forKey: .total_seconds)
        amount = try values.decodeIfPresent(Double.self, forKey: .amount)
        date_at = try values.decodeIfPresent(String.self, forKey: .date_at)
    }
    
}

