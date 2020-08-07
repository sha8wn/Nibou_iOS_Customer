//
//  ChooseExpertWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 04/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit


extension ChooseExpertViewController{
    func callChatSessionApi(expertId: String, arrayExtersie: [String]){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatSession
        let requestDict = ["expert_id"      : expertId,
                           "expertise_ids"  : arrayExtersie
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                setChatRoomCreatedFirstTime(bool: true)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
