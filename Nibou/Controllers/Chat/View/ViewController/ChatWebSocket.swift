//
//  ChatWebSocket.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

extension NBChatVC {
    
    func setUpWebSocket(roomId: String){
        
        let accessTokenModel = getAccessTokenModel()
        
        let webURL = kWebSocketURL + "?access_token=" + "\(accessTokenModel.accessToken)"
        
        self.webClient = ActionCableClient(url: URL(string: webURL)!)
        
    
        self.webClient.willConnect = {
            print("Will Connect")
        }
        
        self.webClient.onConnected = {
            print("Connected to \(self.webClient.url)")
        }
        
        self.webClient.onDisconnected = {(error: ConnectionError?) in
            print("Disconected with error: \(String(describing: error))")
        }
        
        self.webClient.willReconnect = {
            print("Reconnecting to \(self.webClient.url)")
            return true
        }
        
        self.roomChannel = webClient.create("ChatChannel", identifier: ["rid" : "\(roomId)"], autoSubscribe: true, bufferActions: true)
        
        
        self.roomChannel.subscribe()
        
        roomChannel.onSubscribed = {
            print("Subscribed to \(String(describing: self.roomChannel.identifier))")
        }
        
        // A channel was unsubscribed, either manually or from a client disconnect.
        self.roomChannel.onUnsubscribed = {
            print("Unsubscribed")
        }
        
        // The attempt at subscribing to a channel was rejected by the server.
        self.roomChannel.onRejected = {
            print("Rejected")
        }
//        
//        self.webClient.onPing = {
//            print("ChatChannel \(self.roomChannel.isSubscribed)")
//        }
//        
        
        self.roomChannel.onReceive = { (JSON : Any?, error : Error?) in
            print("Received CHAT WS NOTIFICATION", JSON ?? "", error ?? "")
            DispatchQueue.main.async {
                guard let dict = JSON as? NSDictionary else { return }
                var data: Data!
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                    data = jsonData
                }catch let error{
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
                
                do {
                    let responseChatModel = try self.JSONdecoder.decode(ChatSendModel.self, from: data)
                    var needUpdate: Bool = true
                    if responseChatModel.data != nil{
                        if self.chatModel != nil && self.chatModel.count > 0{
                            let listModel: List<ChatData> = self.chatModel[0].data
                            for i in 0..<listModel.count{
                                let model: ChatData! = listModel[i]
                                if model.chatId == responseChatModel.data!.id!{
                                    needUpdate = false
                                    break
                                }else{
                                }
                            }
                        }
                    }
                    
                    if needUpdate{
                        if responseChatModel.data!.attributes!.from_user_id! == Int(getLoggedInUserId()){
                            self.textView_message.text = ""
                        }
                        self.view.layoutIfNeeded()
                        self.view.layoutSubviews()
                        self.view.setNeedsUpdateConstraints()
                        self.updateDataInDatabase(model: responseChatModel, roomId: self.roomId)
                    }else{
                        
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
        // Connect!
        self.webClient.connect()
    }
}
