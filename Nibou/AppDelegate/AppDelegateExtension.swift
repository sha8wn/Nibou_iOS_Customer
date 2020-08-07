//
//  AppDelegateExtension.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

/**
 MARK: - AppDelegate extension
 */
extension AppDelegate
{
    /**
     MARK: - Get App Current Language
     - This function is used to get app language

     - Returns: Language Code String
     */
    func getLanguage() -> String{
        let prefferedLanguage = Locale.preferredLanguages[0]
        let code = prefferedLanguage.components(separatedBy: "-")
        return code.first ?? Locale.preferredLanguages[0]
    }

    /**
     MARK: - Check App Current Language
     - This function is used to check current language and compare that current language is English, Arabic and Turkish or not

     - Returns: Bool(Check current language is English, Arabic and Turkish or not)
     */
    func checkCurrentLanguage(language: String) -> Bool{
        if language == "en"{
            return true
        }else if language == "tr"{
            return true
        }else if language == "ar"{
            return true
        }else{
            return false
        }
    }

    func triggerLocalNotification(title: String? = "", subtitle: String? = "", body: String? = "", userInfo: [AnyHashable : Any]){
        let content = UNMutableNotificationContent()
        content.title = title ?? ""
        content.subtitle = subtitle ?? ""
        content.body = body ?? ""
        content.sound = .default
        content.badge = 0
        content.userInfo = userInfo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "WS_NOTIFICATION_HEADER".localized(), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func handleWebSocketNotification(webSocketData: NSDictionary? = nil){
        var model: WebSocketNotificationModel!
        var data: Data!
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: webSocketData!, options: .prettyPrinted)
            data = jsonData
        }catch let error{
            print(error.localizedDescription)
        }
        
        do {
            let notificationModel = try JSONDecoder().decode(WebSocketNotificationModel.self, from: data)
            print(notificationModel)
            model = notificationModel
        } catch let error {
            print(error.localizedDescription)
        }
        let state = UIApplication.shared.applicationState
        if model != nil{
            if model.action! == "new_chat_room"{
                self.triggerLocalNotification(title: "NEW_CHAT_ROOM_TITLE".localized(), subtitle: "NEW_CHAT_ROOM_SUBTITLE".localized(), body: "NEW_CHAT_ROOM_BODY".localized(), userInfo: webSocketData as! [AnyHashable : Any])
            }else if model.action! == "session_end"{
                var expertName: String = ""
                var expertId: Int = 0
                for i in 0...model.room!.data!.attributes!.users!.count - 1{
                    let subModel = model.room!.data!.attributes!.users![i]
                    if getLoggedInUserId() == subModel.data!.id!{
                        //NOT REQUIRED
                    }else{
                        guard let userName = subModel.data!.attributes!.name else{ return }
                        expertName = userName
                        expertId = Int(subModel.data!.id!)!
                    }
                }
                self.triggerLocalNotification(title: "Nibou", subtitle: String(format: "END_SESSION_TITLE".localized(), "\(expertName)"), body: String(format: "END_SESSION_BODY".localized(), "\(expertName)"), userInfo: webSocketData as! [AnyHashable : Any])
                
                self.openRateViewController(roomId: model.room!.data!.id!, expertId: expertId, expertName: "\(expertName)")
                
                let dict: [String: String] = ["roomId" : "\(model.room!.data!.id!)"]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RELOAD_HOME_DATA"), object: dict)
            }else if model.action! == "session_timeout"{
                if state == .background || state == .inactive{
                    self.triggerLocalNotification(title: "Nibou", subtitle: "SESSION_TIMEOUT".localized(), body: "", userInfo: webSocketData as! [AnyHashable : Any])
                }else{
                    var expertName: String = ""
                    for i in 0...model.room!.data!.attributes!.users!.count - 1{
                        let subModel = model.room!.data!.attributes!.users![i]
                        if getLoggedInUserId() == subModel.data!.id!{
                            //NOT REQUIRED
                        }else{
                            guard let userName = subModel.data!.attributes!.name else{ return }
                            expertName = userName
                        }
                    }
                    
                    if getCurrentLanguage() == "ar" || getCurrentLanguage() == "tr"{
                        self.showAlert(alertTitle: "SESSION_TIMOUT_INACTIVE_HEADER".localized(), alertMessage: String(format: "INACTIVE_POPUP_DESC".localized(), "\(expertName)", "\(model.timeout ?? "5")"), okTitleString: "CONTINUE".localized(), cancelTitleString: "END".localized(), type: .sessionTimeout, model: model!)
                    }else{
                        self.showAlert(alertTitle: "SESSION_TIMOUT_INACTIVE_HEADER".localized(), alertMessage: String(format: "INACTIVE_POPUP_DESC".localized(), "\(model.timeout ?? "5")" , "\(expertName)"), okTitleString: "CONTINUE".localized(), cancelTitleString: "END".localized(), type: .sessionTimeout, model: model!)
                    }
                    
                    
                }
            }else if model.action! == "user_offline"{
                var array = getOfflineData()
                if array.count > 0{
                    var isExpertAlreadyExist: Bool = false
                    for i in 0...array.count - 1{
                        if array[i] == "\(model.user_id!)"{
                            isExpertAlreadyExist = true
                        }else{
                        }
                    }
                    if isExpertAlreadyExist{
                    }else{
                        array.append("\(model.user_id!)")
                        setOfflineData(array: array)
                    }
                }else{
                    setOfflineData(array: ["\(model.user_id!)"])
                }
                if state == .background || state == .inactive{

                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Expert_Offline"), object: nil)
                }
            }else if model.action! == "user_online"{
                var array = getOfflineData()
                if array.count > 0{
                    for i in 0...array.count - 1{
                        if array[i] == "\(model.user_id!)"{
                            array.remove(at: i)
                            setOfflineData(array: array)
                        }else{
                        }
                    }
                }else{
                }
                if state == .background || state == .inactive{
                    
                }else{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Expert_Online"), object: nil)
                }
            }
            else if model.action! == "new_message"{
                print("new_message")

                var arrayNewMessage = getNewMessageData()
                var isUpdate: Bool  = false
                var indexToUpdate: Int = 0
                
                if arrayNewMessage.count > 0{
                    for i in 0...arrayNewMessage.count - 1{
                        var dictNewMessage = arrayNewMessage[i]
                        if dictNewMessage["roomId"] as! String == "\(model.room!.data!.id!)"{
                            isUpdate = true
                            indexToUpdate = i
                        }else{
                            
                        }
                    }
                    if isUpdate{
                        var dictNewMessage = arrayNewMessage[indexToUpdate]
                        if let lastMessageModel: ChatSendModel = model!.message{
                            if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                                dictNewMessage["newMessageCount"] = dictNewMessage["newMessageCount"] as! Int + 1
                                dictNewMessage["lastMessageTimestamp"] = "\(lastMessageModel.data!.attributes!.created_at ?? "")"
                                arrayNewMessage[indexToUpdate] = dictNewMessage
                                kUserDefault.removeObject(forKey: kNewMessage)
                                kUserDefault.synchronize()
                                setNewMessageData(array: arrayNewMessage)
                            }else{
                            }
                        }
                    }else{
                        if let lastMessageModel  = model!.message{
                            if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                                let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                                    "newMessageCount": 1,
                                    "lastMessageTimestamp": "\(lastMessageModel.data!.attributes!.created_at ?? "")"
                                ]
                                arrayNewMessage.append(dict)
                                kUserDefault.removeObject(forKey: kNewMessage)
                                kUserDefault.synchronize()
                                setNewMessageData(array: arrayNewMessage)
                                //                                return
                            }else{
                            }
                        }
                    }
                }else{
                    if let lastMessageModel  = model!.message{
                        if lastMessageModel.data!.attributes!.to_user_id ?? 0 == Int(getLoggedInUserId()){
                            let dict: [String: Any] = ["roomId" : "\(model.room!.data!.id!)",
                                "newMessageCount": 1,
                                "lastMessageTimestamp": "\(lastMessageModel.data!.attributes!.created_at ?? "")"
                            ]
                            arrayNewMessage.append(dict)
                            setNewMessageData(array: arrayNewMessage)
                        }else{
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW_MESSAGE"), object: nil)
            }
        }
    }
    
    func handlePushNotification(data: [AnyHashable : Any]? = nil){
        let dict = data as! [AnyHashable: Any]
        print(dict as! [String: Any])
        
        var isLocalNotification: Bool = false
        if let isLocal = dict["localNotification"] as? Bool{
            isLocalNotification = isLocal
        }else{
            isLocalNotification = false
        }
        
        if isLocalNotification == true{
            //HANDLE LOCAL NOTIFICATION
        }else{
            //HANDLE PUSH NOTIFICATION
            
            if dict["action"] as? String != nil{
                //Notification type
                let type = dict["action"] as! String
                if type == "new_chat_room"{
                    
                }else if type == "session_timeout"{
                    
                    let roomId = dict["room_id"] as? String
                    self.callSendMessageAPi(roomId: roomId ?? "", fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: ["text" : "END_SESSION"])
                    
                }else if type == "session_end"{
                    let roomId = dict["room_id"] as? String
                    let notification = dict["notification"] as? String
                    
                    if let data = notification!.data(using: String.Encoding.utf8) {
                        do {
                            let notificationDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                            let expertId = notificationDict!["user_id"] as? Int
                            let expertName = notificationDict!["user_name"] as? String
                            self.openRateViewController(roomId: roomId!, expertId: expertId!, expertName: expertName!)
                        }catch {
                            
                        }
                    }
                    let dict: [String: String] = ["roomId" : "\(roomId)"]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RELOAD_HOME_DATA"), object: dict)
                }else if type == "new_message"{
                    let roomId = dict["room_id"] as? String
                    let message = dict["message"] as? String
                    if let data = message!.data(using: String.Encoding.utf8) {
                        do {
                            let messageDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                            let toUserId = messageDict!["to_user_id"] as? Int
                            
                            let lastMessageText = messageDict!["text"] as? String
                            var arrayNewMessage = getNewMessageData()
                            var isUpdate: Bool  = false
                            var indexToUpdate: Int = 0
                            
                            if arrayNewMessage.count > 0{
                                for i in 0...arrayNewMessage.count - 1{
                                    var dictNewMessage = arrayNewMessage[i]
                                    if dictNewMessage["roomId"] as! String == "\(String(describing: roomId))"{
                                        isUpdate = true
                                        indexToUpdate = i
                                    }else{
                                        
                                    }
                                }
                                print("UPDATE: \(isUpdate)")
                                if isUpdate{
                                    var dictNewMessage = arrayNewMessage[indexToUpdate]
                                    if toUserId == Int(getLoggedInUserId()){
                                        dictNewMessage["newMessageCount"] = dictNewMessage["newMessageCount"] as! Int + 1
                                        dictNewMessage["lastMessage"] = "\(lastMessageText ?? "")"
                                        arrayNewMessage[indexToUpdate] = dictNewMessage
                                        kUserDefault.removeObject(forKey: kNewMessage)
                                        kUserDefault.synchronize()
                                        setNewMessageData(array: arrayNewMessage)
                                    }else{
                                    }
                                }else{
                                    if toUserId == Int(getLoggedInUserId()){
                                        let dict: [String: Any] = ["roomId" : "\(String(describing: roomId))",
                                            "newMessageCount": 1,
                                            "lastMessage": "\(lastMessageText ?? "")"
                                        ]
                                        arrayNewMessage.append(dict)
                                        kUserDefault.removeObject(forKey: kNewMessage)
                                        kUserDefault.synchronize()
                                        setNewMessageData(array: arrayNewMessage)
                                        //                                return
                                    }else{
                                    }
                                }
                            }else{
                                if toUserId == Int(getLoggedInUserId()){
                                    let dict: [String: Any] = ["roomId" : "\(String(describing: roomId))",
                                        "newMessageCount": 1,
                                        "lastMessage": "\(lastMessageText ?? "")"
                                    ]
                                    arrayNewMessage.append(dict)
                                    setNewMessageData(array: arrayNewMessage)
                                }else{
                                }
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NEW_MESSAGE"), object: nil)
                        } catch {
                            
                        }
                    }
                }else{
                    
                }
            }
        }
    }
    
    func showAlert(alertTitle: String? = "", alertMessage: String? = "", okTitleString: String? = "", cancelTitleString: String? = "", type: NotificationType, data: [AnyHashable : Any]? = nil, model: WebSocketNotificationModel? = nil){
        let alertViewC = commonStoryboard.instantiateViewController(withIdentifier: "NotificationAlertViewController") as! NotificationAlertViewController
        alertViewC.titleStr = alertTitle
        alertViewC.messageStr = alertMessage
        alertViewC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertViewC.okTitleString = okTitleString
        alertViewC.cancelTitleString = cancelTitleString
        alertViewC.notificationType = type
        alertViewC.notificationModel = model
        alertViewC.notificationData = data
        self.window?.rootViewController?.present(alertViewC, animated: false, completion: nil)
    }
    
    func openRateViewController(roomId: String, expertId: Int, expertName: String){
        self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        let rateScreenViewC = commonStoryboard.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        rateScreenViewC.roomId = roomId
        rateScreenViewC.expertName = expertName
        rateScreenViewC.expertId = expertId
        self.window?.rootViewController?.present(rateScreenViewC, animated: false, completion: nil)
    }
}

