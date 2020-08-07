//
//  File.swift
//  Nibou
//
//  Created by Himanshu Goyal on 09/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications


enum NotificationType{
    case sessionTimeout
    case newChatRoom
    case userOffline
}

extension AppDelegate {
    
    func setUpWebSocket(){
        
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
            self.notficationChannel.action("offline")
            print("Disconected with error: \(String(describing: error))")
        }
        
        self.webClient.willReconnect = {
            print("Reconnecting to \(self.webClient.url)")
            return true
        }
        
        self.notficationChannel = self.webClient.create("UserNotificationChannel", identifier: nil, autoSubscribe: true, bufferActions: true)

        self.webClient.subscribe(self.notficationChannel)
        
        self.notficationChannel.subscribe()
        
//        self.notficationChannel.onSubscribed = {
////            print("Subscribed to \(String(describing: self.notficationChannel.identifier))")
//        }

        // A channel was unsubscribed, either manually or from a client disconnect.
        self.notficationChannel.onUnsubscribed = {
//            print("Unsubscribed")
        }
        
        // The attempt at subscribing to a channel was rejected by the server.
        self.notficationChannel.onRejected = {
//            print("Rejected")
        }
        
        var count: Int = 0
        self.webClient.onPing = {
            count = count + 1
            if count == 10{
//                print("ONLINE 10")
//                self.notficationChannel.action("online")
                count = 0
            }
            self.notficationChannel.action("online")
//            print("UserNotification is Connected")
        }
        
        self.notficationChannel.onReceive = { (JSON : Any?, error : Error?) in
            print("Received WS NOTIFICATION: ", JSON, error)
            guard let dict = JSON as? NSDictionary else { return }
            var responseDict = NSMutableDictionary(dictionary: dict)
            responseDict["localNotification"] = true            
            self.handleWebSocketNotification(webSocketData: responseDict as NSDictionary)
        }
        
        // Connect!
        self.webClient.connect()
        
    }
}

