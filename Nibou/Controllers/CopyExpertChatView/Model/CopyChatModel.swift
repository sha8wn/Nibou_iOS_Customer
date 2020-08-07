//
//  CopyChatModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

struct CopyChatModel : Codable {
    let data : HomeData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(HomeData.self, forKey: .data)
    }
}
