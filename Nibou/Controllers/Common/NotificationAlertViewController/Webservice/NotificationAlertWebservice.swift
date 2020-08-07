//
//  NotificationAlertWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension NotificationAlertViewController{
    
    func callSendMessageAPi(roomId: String, fileData: [Data]?, fileName: [String]?, paramsArray: [String]?, mineType: [String]?, requestDict: [String: Any]? = nil){
        
        self.showLoader(message: "LOADING".localized())
        
        let urlPath = kBaseURL + kChatSendMessage + roomId
        
        Network.shared.multipartRequest(urlPath: urlPath, methods: .post, paramName: paramsArray, fileData: fileData, fileName: fileName, mineType: mineType, uploadDict: requestDict) { (response, message, statusCode, status) in
            
            self.hideLoader()
            if status == .Success{
                self.dismiss(animated: false, completion: nil)
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func endSessionAPi(roomId: String){
        let urlPath = kBaseURL + kEndChatSession + roomId
        
        Network.shared.request(urlPath: urlPath, methods: .delete, authType: .auth) { (response, message, statusCode, status) in
            if status == .Success{
                NotificationCenter.default.post(name: Notification.Name("ChatRoom_Session_End"), object: nil)
                self.dismiss(animated: false, completion: nil)
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
