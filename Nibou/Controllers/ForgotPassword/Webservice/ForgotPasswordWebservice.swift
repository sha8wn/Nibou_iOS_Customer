//
//  ForgotPasswordWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 28/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension ForgotPasswordViewController{
    
    func callForgotPasswordApi(email: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kForgotPassword + "?email=" + "\(email.addingPercentEncodingForQueryParameter() ?? "")"
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .basic) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.isSuccess = true
                self.showAlert(viewController: self, alertTitle: "SUCCESS".localized(), alertMessage: "RESET_PASSWORD_SUCCESS_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                     self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "RESET_PASSWORD_FAILURE".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
}


