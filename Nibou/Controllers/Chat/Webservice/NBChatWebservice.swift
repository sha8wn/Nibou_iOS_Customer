//
//  NBChatWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension NBChatVC{
    
    func callGetRoomDetailApi(roomId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetRoomDetails + roomId
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                print("ROOM:\(roomId)")
                self.isRoomFound = true
                self.callGetChatHistory(roomId: self.roomId)
            }else{
                self.isRoomFound = false
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "CHAT_SESSION_ALREADY_ENDED".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callSendMessageAPi(roomId: String, fileData: [Data]?, fileName: [String]?, paramsArray: [String]?, mineType: [String]?, requestDict: [String: Any]? = nil){
        
        let urlPath = kBaseURL + kChatSendMessage + roomId
        
        Network.shared.multipartRequest(urlPath: urlPath, methods: .post, paramName: paramsArray, fileData: fileData, fileName: fileName, mineType: mineType, uploadDict: requestDict) { (response, message, statusCode, status) in
            if status == .Success{
                
            }else{
                self.view.endEditing(true)
                
                DispatchQueue.main.async {
                    
                    let mainModel = self.relamDB.objects(ChatModel.self).filter("roomId = %@", roomId)
                    
                    if self.chatModel != nil && self.chatModel.count > 0{
                        let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.chatModel[0].data.count)")
                        
                        
                        if let model = previousDataModel.first{
                            try! self.relamDB.write {
                                self.relamDB.delete(previousDataModel)
                            }
                        }else {
                            let previousDataModel = mainModel[0].data.filter("chatId = %@", "\(self.roomId)")
                            if let model = previousDataModel.first{
                                try! self.relamDB.write {
                                    self.relamDB.delete(previousDataModel)
                                }
                            }
                        }
                    }else{
                        let previousDataModel = mainModel[0].data.filter("localId = %@", "\(self.roomId)")
                        if let model = previousDataModel.first{
                            try! self.relamDB.write {
                                self.relamDB.delete(previousDataModel)
                            }
                        }
                    }
                    
                    
                    self.chatModel = self.getDataFromDatabase(roomId: self.roomId)
                    self.table_view.reloadData()
                }

                if let responseDict = response!.result.value as? NSDictionary{
                    if let error = responseDict.value(forKey: "errors") as? NSArray{
                        if let errorDict = error[0] as? NSDictionary{
                            if let sourceDict = errorDict.value(forKey: "source") as? NSDictionary{
                                print(sourceDict)
                                let pointer = sourceDict.value(forKey: "pointer") as! String
                                print(pointer)
                                if pointer == "/data/attributes/from_user_id"{
                                    self.isCardError = true
                                }else{
                                    self.isCardError = false
                                }
                            }
                        }
                    }
                    if self.isCardError{
                        self.showAlert(viewController: self, alertTitle: "INVALID_CARD_TITLE".localized(), alertMessage: "INVALID_CARD_DESC".localized(), alertType: .oneButton, singleButtonTitle: "INVALID_ADD_CARD".localized())
                    }else{
                        self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                    }
                }
                
             
                
            }
        }
    }
    
    
    
    func callGetChatHistory(roomId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetChatHistory + roomId
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let chatModel = try self.JSONdecoder.decode(ChatHistoryModel.self, from: response?.data ?? Data())
                    
                    if self.chatModel.count > 0{
                        
                    }
                    
                    self.setDataInDatabase(model: chatModel, roomId: self.roomId)
                    
                    self.setUpExpertStatus()
                    self.setupNewMessageCount()
//                    self.callGetRoomDetailApi(roomId: self.homeDataModel.id!)
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{

            }
        }
    }

    func callGetExpertProfileDataAPI(expertId: String, expertName: String){
        let urlPath = kBaseURL + kGetExpertProfile + "/" + "\(expertId)" + "?include=user_timings"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                let responseDict = response!.result.value as! NSDictionary
                let timingsModel = self.getUpcomingAvailExpertTiming(profileDict: responseDict)
                let message = String(format: "EXPERT_OFFILE_MESSAGE".localized(), "\(expertName)",  "\(timingsModel.day ?? "")", "\(timingsModel.time ?? "")")
                var statusArray = getOfflineData()
                if statusArray.count > 0{
                    for i in 0...statusArray.count - 1{
                        if statusArray[i] == self.expertId{
                            if self.isOfflinePopupOpen == false{
                                self.isOfflinePopupOpen = true
                                self.showAlert(viewController: self, alertTitle: "EXPERT_OFFLINE_ALERT_TITLE".localized(), alertMessage: message, alertType: .twoButton, okTitleString: "EXPERT_OFFLINE_LEAVE_MESSAGE".localized(), cancelTitleString: "EXPERT_OFFLINE_SWITCH_EXPERT".localized())
                            }
                        }else{
                            
                        }
                    }
                }else{
                    self.isOfflinePopupOpen = false
                    self.dismiss(animated: false, completion: nil)
                }
                
                
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func getUpcomingAvailExpertTiming(profileDict: NSDictionary) -> Timings{
        var arrayOfTimings: [Timings] = []
        let weekDays = ["MONDAY".localized(), "TUESDAY".localized(), "WEDNESDAY".localized(), "THRUSDAY".localized(), "FRIDAY".localized(), "SATURDAY".localized(), "SUNDAY".localized()]
        if let includedArray = profileDict.value(forKey: "included") as? NSArray{
            if includedArray.count > 0{
                for i in 0...includedArray.count - 1{
                    if let subDict = includedArray[i] as? NSDictionary{
                        if let attributeDict = subDict.value(forKey: "attributes") as? NSDictionary{
                            if let includedtype = subDict.value(forKey: "type") as? String{
                                if includedtype == "user_timings"{
                                    var model = Timings()
                                    if let dayNumber = attributeDict.value(forKey: "day_number") as? Int{
                                        model.day = weekDays[dayNumber - 1]
                                        
                                        let startTime = attributeDict.value(forKey: "time_from") as! String
                                        let endTime = attributeDict.value(forKey: "time_to") as! String
                                        
                                        let timedateFormatter24h = DateFormatter()
                                        timedateFormatter24h.dateFormat = "HH:mm"
                                        let start24h = timedateFormatter24h.date(from: startTime)
                                        
                                        let end24h = timedateFormatter24h.date(from: endTime)
                                        
                                        
                                        let timedateFormatter = DateFormatter()
                                        timedateFormatter.dateFormat = "h:mm a"
                                        let timeA = timedateFormatter.string(from: start24h ?? Date())
                                        
                                        let timeB = timedateFormatter.string(from: end24h ?? Date())
                                        
                                        model.time = timeA + " - " + timeB
                                        
                                    }
                                    
                                    arrayOfTimings.append(model)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var currentDayNumber = Calendar.current.component(.weekday, from: Date())
        currentDayNumber = currentDayNumber - 2
        var selectedModel: Timings = Timings()
        for model in arrayOfTimings{
            let index = weekDays.lastIndex(of: model.day!)
            if index! > currentDayNumber{
                selectedModel = model
            }else{
                selectedModel = arrayOfTimings[0]
            }
        }
        return selectedModel
    }
    
    func callEndConversionAPI(roomId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kEndConversion  + roomId
        Network.shared.request(urlPath: urlPath, methods: .delete, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.navigationController?.popViewController(animated: true)
//                self.isChatEnded = true
//                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "CHAT_CONVERSAION_ENDED".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
