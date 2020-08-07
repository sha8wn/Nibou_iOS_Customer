//
//  RealmDataModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import RealmSwift


class ChatModel: Object{
    @objc dynamic var roomId        = ""
    let data                        = List<ChatData>()
}

class ChatData: Object {
    @objc dynamic var localId             = ""
    @objc dynamic var chatId              = ""
    @objc dynamic var toUserId            = 0
    @objc dynamic var fromUserId          = 0
    @objc dynamic var message             = ""
    @objc dynamic var localImageUrl       = ""
    @objc dynamic var timeStamp           = ""
    @objc dynamic var imageUrl            = ""
    @objc dynamic var showHeader          = false
    @objc dynamic var showHeaderForToday  = false
//    let arrayImagesURL                    = List<ChatImageData>()
}

//class ChatImageData: Object {
//    @objc dynamic var url                 = ""
//}
