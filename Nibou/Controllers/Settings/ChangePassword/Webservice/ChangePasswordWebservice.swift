//
//  File.swift
//  Nibou
//
//  Created by Himanshu Goyal on 28/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension ChangePasswordViewController{
  
    func callChangePasswordApi(currentPassword: String, newPassword: String, confirmPassword: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChangePassword
        
        let requestDict = ["old_password"           : "\(currentPassword)",
                           "password"               : "\(newPassword)",
                           "password_confirmation"  : "\(confirmPassword)"
            ] as [String : Any]
  
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isChangePasswordSuccess = true
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized() , alertMessage: "PASSWORD_CHANGE_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
}

