//
//  FeedbackWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 25/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension FeedbackViewController{

    func callUpdateFeedbackApi(subject: String, message: String){
        
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kFeedback
        
        let requestDict = ["subject"  : "\(subject)",
                           "message"  : "\(message)"
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isAddedSuccesfully = true
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "SUBMITTED_FEEDBACK_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}


