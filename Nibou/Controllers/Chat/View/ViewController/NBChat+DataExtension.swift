//
//  NBChat+DataExtension.swift
//  Nibou
//
//  Created by Himanshu Goyal on 12/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SDWebImage

extension NBChatVC{
    
    func setUpHeaderView(model: HomeData){
        //Room Id
        self.roomId = model.id!
        
        //Room Type
        self.roomType = model.type!
        
//        self.callGetChatHistory(roomId: self.roomId)
        
        self.callGetRoomDetailApi(roomId: self.homeDataModel.id!)
        
        //Get Header Data
        for i in 0...model.attributes!.users!.count - 1{
            let subModel = model.attributes!.users![i]
            if getLoggedInUserId() == subModel.data!.id!{
                //NOT REQUIRED
            }else{
                //Profile Pic
                var url: String = ""
                if let profilePicURL = subModel.data!.attributes!.avatar!.url{
                    url = kBaseURL + profilePicURL
                }else{
                    url = ""
                }
                self.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                self.imgProfile.sd_setShowActivityIndicatorView(true)
//                self.imgProfile.sd_setIndicatorStyle(.gray)
                if url != ""{
                    self.imgProfile.sd_setImage(with: URL(string: url), completed: nil)
                }else{
                    self.imgProfile.image = UIImage(named: "profile_icon_iPhone")
                }
                
                //Expert Id
                self.expertId = subModel.data!.id!
                
                //Profile Name
                guard let userName = subModel.data!.attributes!.name else{ return }
                self.lblUserName.text = userName
                
                //Online / Offline
                
                if let status = subModel.data!.attributes!.available{
                    if status == true{
                        self.imgUserState.image = UIImage(named: "green_icon_iPhone")
                    }else{
                        self.imgUserState.image = UIImage(named: "ic_offline")
                    }
                }else{
                    self.imgUserState.image = UIImage(named: "ic_offline")
                }
            }
        }
    }
    
    /// MARK: - Update TableView Header With Date
    ///
    /// - Parameter timeStamp: Date from Server
    /// - Returns: showDate, ShowCurrentDate
    func setUpDateHeader(timeStamp: String) -> (Bool, Bool){
        let strDate = timeStamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: strDate)
        let (_, day) = Date().calculateMessageTimestampfrom(date: date!)
        if day > 0{
            if self.previousDayCount != day{
                self.previousDayCount = day
                return (true, false)
            }else{
                return (false, false)
            }
        }else{
            if self.showDateCurrentDay != 1{
                self.showDateCurrentDay = 1
                return (true, true)
            }else{
                return (false, false)
            }
        }
    }
    
    
    /// MARK: - Set up TableView With Data
    ///
    /// - Parameter roomId: Unique Id
    func setUpTableViewWithData(roomId: String){
        self.chatModel = self.getDataFromDatabase(roomId: roomId)
        DispatchQueue.main.async {
            self.table_view.reloadData()
        }
    }
    
    /// MARK: - Get Data From Database i.e Realm
    ///
    /// - Returns: Result of Chat Model Type
    func getDataFromDatabase(roomId: String) -> Results<ChatModel>{
        let results: Results<ChatModel> = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
        return results
    }

    func setDataInDatabase(model: ChatHistoryModel, roomId: String){
        
//        self.deleteDataFromDatabase(roomId: self.roomId)
        if model.data!.count > 0{
            let dataBaseResult = getDataFromDatabase(roomId: roomId)
            if dataBaseResult.count > 0{
                
                print("DATABASE DATE COUNT: \(dataBaseResult[0].data.count)")
                print("MODEL DATE COUNT: \(model.data!.count)")
                
                if dataBaseResult[0].data.count < model.data!.count{
                    for i in 0...model.data!.count - 1{
                        let chatData = model.data![i]
                        let subModel = ChatData()
                        subModel.chatId = chatData.id!
                        subModel.toUserId = chatData.attributes!.to_user_id!
                        subModel.localId = ""
                        subModel.fromUserId = chatData.attributes!.from_user_id!
                        subModel.timeStamp = chatData.attributes!.created_at!
                        subModel.message = chatData.attributes!.text ?? ""
                        if let arrayImage = chatData.attributes!.images{
                            if arrayImage.count > 0{
                                for object in arrayImage{
                                    if object.data!.attributes!.images!.count > 0{
                                        subModel.imageUrl = object.data!.attributes!.images![0].url!
                                    }
                                }
                            }
                        }
                        if chatData.attributes!.text ?? "" == "END_SESSION"{
                            //NO NEED TO UPDATE
                            print("END_SESSION")
                        }else{
                            let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
                            
                            if i > dataBaseResult[0].data.count - 1{
                                if let mainModel = mainModel.first {
                                    try! self.relamDB.write {
                                        mainModel.data.append(subModel)
                                    }
                                }
                            }
                            
//                            if let mainModel = mainModel.first {
//                                try! self.relamDB.write {
//                                    mainModel.data.append(subModel)
//                                }
//                            }
                        }
                    }
                }else{
                    ////
                    print("NOT NEED TO UPDATE")
                }
            }else{
                //Delete Old Data
                self.deleteDataFromDatabase(roomId: self.roomId)
  
                //Add New Data
                let mainModel = ChatModel()
                mainModel.roomId = roomId
                for i in 0...model.data!.count - 1{
                    let subModel = ChatData()
                    let chatData = model.data![i]
                    subModel.localId = ""
                    subModel.chatId = chatData.id!
                    subModel.toUserId = chatData.attributes!.to_user_id!
                    subModel.fromUserId = chatData.attributes!.from_user_id!
                    subModel.timeStamp = chatData.attributes!.created_at!
                    subModel.message = chatData.attributes!.text ?? ""
                    
                    let (showDate, showCurrentDate) = self.setUpDateHeader(timeStamp: chatData.attributes!.created_at!)
                    subModel.showHeader = showDate
                    subModel.showHeaderForToday = showCurrentDate
                    if let arrayImage = chatData.attributes!.images{
                        if arrayImage.count > 0{
                            for object in arrayImage{
                                if object.data!.attributes!.images!.count > 0{
                                    subModel.imageUrl = object.data!.attributes!.images![0].url!
                                }
                            }
                        }
                    }
                    if chatData.attributes!.text ?? "" == "END_SESSION"{
                        //NO NEED TO UPDATE
                        print("END_SESSION")
                    }else{
                        mainModel.data.append(subModel)
                    }
                }
                
                try! relamDB.write {
                    relamDB.add(mainModel)
                }
            }
        }
            
        self.chatModel = self.getDataFromDatabase(roomId: roomId)

        DispatchQueue.main.async {
            self.table_view.reloadData()
            self.scrollToTheBottom(animated: false, position: .bottom)
        }
    }
    
    
    
    func updateDataInDatabase(model: ChatSendModel, roomId: String){
        let subModel = ChatData()
        let chatData = model.data!
        subModel.chatId = chatData.id!
        subModel.toUserId = chatData.attributes!.to_user_id!
        subModel.fromUserId = chatData.attributes!.from_user_id!
        subModel.timeStamp = chatData.attributes!.created_at!
        subModel.message = chatData.attributes!.text ?? ""
        if let arrayImage = chatData.attributes!.images{
            if arrayImage.count > 0{
                for object in arrayImage{
                    if object.data!.attributes!.images!.count > 0{
                        subModel.imageUrl = object.data!.attributes!.images![0].url!
                    }
                }
            }
        }

        if chatData.attributes!.text ?? "" == "END_SESSION"{
            //NO NEED TO UPDATE
            print("END_SESSION")
        }else{
            let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
            
            if subModel.fromUserId != Int(getLoggedInUserId()) ?? 0{
                
                if let mainModel = mainModel.first {
                    try! self.relamDB.write {
                        mainModel.data.append(subModel)
                    }
                }
                self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
                
            }else{
                if self.chatModel != nil && self.chatModel.count > 0{
                    
                    let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.chatModel[0].data.count)")
                    
                    if let previousDataModel = previousDataModel.first{
                        try! self.relamDB.write {
                            previousDataModel.chatId = subModel.chatId
                            previousDataModel.localId = ""
                            previousDataModel.toUserId = subModel.toUserId
                            previousDataModel.fromUserId = subModel.fromUserId
                            previousDataModel.timeStamp = subModel.timeStamp
                            previousDataModel.message = subModel.message
                            previousDataModel.imageUrl = subModel.imageUrl
                        }
                    }else {
                        let previousDataModel = mainModel[0].data.filter("chatId = %@", "\(self.roomId)")
                        if let previousDataModel = previousDataModel.first{
                            try! self.relamDB.write {
                                previousDataModel.chatId = subModel.chatId
                                previousDataModel.localId = ""
                                previousDataModel.toUserId = subModel.toUserId
                                previousDataModel.fromUserId = subModel.fromUserId
                                previousDataModel.timeStamp = subModel.timeStamp
                                previousDataModel.message = subModel.message
                                previousDataModel.imageUrl = subModel.imageUrl
                            }
                        }
                    }
                }else{
                    let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.roomId)")
                    if let previousDataModel = previousDataModel.first{
                        try! self.relamDB.write {
                            previousDataModel.chatId = subModel.chatId
                            previousDataModel.localId = ""
                            previousDataModel.toUserId = subModel.toUserId
                            previousDataModel.fromUserId = subModel.fromUserId
                            previousDataModel.timeStamp = subModel.timeStamp
                            previousDataModel.message = subModel.message
                            previousDataModel.imageUrl = subModel.imageUrl
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            self.table_view.reloadData()
            let visibleLastCellIndexPath = self.table_view.indexPathsForVisibleRows!.last
            if self.chatModel[0].data.count == visibleLastCellIndexPath!.section + 1{
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }
    }
    
    func deleteDataFromDatabase(roomId: String){
        let object = relamDB.objects(ChatModel.self).filter("roomId = %@", roomId).first
        try! relamDB.write {
            if let obj = object {
                self.relamDB.delete(obj)
            }
        }
    }

    
    func updateDataBaseWithTempData(chatId: String, localId: String, message: String? = "", localPathURL: String? = ""){
        let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
        if mainModel.count > 0{
            let subModel = ChatData()
            subModel.chatId = chatId
            subModel.localId = localId
            subModel.toUserId = Int(self.expertId) ?? 0
            subModel.fromUserId = Int(getLoggedInUserId()) ?? 0
            subModel.timeStamp = ""
//            subModel.timeStamp = convertDateFormater(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            subModel.message = message ?? ""
            subModel.localImageUrl = localPathURL ?? ""
            if let mainModel = mainModel.first {
                try! self.relamDB.write {
                    mainModel.data.append(subModel)
                }
            }
            self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
            
            DispatchQueue.main.async {
                self.table_view.reloadData()
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }else{
            let model = ChatModel()
            model.roomId = self.roomId
            let subModel = ChatData()
            subModel.chatId = chatId
            subModel.localId = localId
            subModel.toUserId = Int(self.expertId) ?? 0
            subModel.fromUserId = Int(getLoggedInUserId()) ?? 0
//            subModel.timeStamp = convertDateFormater(date: Date(), format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            subModel.timeStamp = ""
            subModel.message = message ?? ""
            subModel.localImageUrl = localPathURL ?? ""
            model.data.append(subModel)
            try! relamDB.write {
                relamDB.add(model)
            }
            self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
            
            DispatchQueue.main.async {
                self.table_view.reloadData()
                self.scrollToTheBottom(animated: false, position: .bottom)
            }
        }
    }
}

func getLoggedInUserId() -> String{
    let model = getProfileModel()
    return model?.data!.id! ?? ""
}

