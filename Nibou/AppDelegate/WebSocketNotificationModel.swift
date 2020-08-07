//
//  WebSocketNotificationModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LoginModel
struct WebSocketNotificationModel: Codable {
    let action: String?
    let room: CopyChatModel?
    let user_id: Int?
    var localNotification: Bool?
    var message: ChatSendModel?
    let timeout: String?

    
    enum CodingKeys: String, CodingKey {
        case action = "action"
        case room = "room"
        case user_id = "user_id"
        case localNotification = "localNotification"
        case message = "message"
        case timeout = "timeout"

    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        action = try values.decodeIfPresent(String.self, forKey: .action)
        room = try values.decodeIfPresent(CopyChatModel.self, forKey: .room)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        localNotification = try values.decodeIfPresent(Bool.self, forKey: .localNotification)
        message = try values.decodeIfPresent(ChatSendModel.self, forKey: .message)
        timeout = try? values.decodeIfPresent(String.self, forKey: .timeout)
    }
}
