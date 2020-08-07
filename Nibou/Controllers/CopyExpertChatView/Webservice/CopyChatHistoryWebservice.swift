//
//  CopyChatHistoryWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension CopyExpertChatViewController{
    
    func callCopyChatApi(expertId: String, roomId: String, isPrivate: Bool){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kCopyChat + "\(roomId)"
        let requestDict = ["expert_id"      : expertId,
                           "is_private"     : isPrivate
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let model = try self.JSONdecoder.decode(CopyChatModel.self, from: response?.data ?? Data())
                    let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "NBChatVC") as! NBChatVC
                    chatVC.homeDataModel = model.data!
                    chatVC.isOpenFrom = .switchExpert
                    self.navigationController?.pushViewController(chatVC, animated: true)
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callChatSessionApi(expertId: String, arrayExtersie: [String], isPrivate: Bool){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatSession
        let requestDict = ["expert_id"      : expertId,
                           "expertise_ids"  : arrayExtersie,
                           "is_private"     : isPrivate
            ] as [String : Any]

        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
//                self.isError = true
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
}
