//
//  SignUpWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 24/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension SignUpViewController{
    
    func callSignUpApi(emailAddress: String, password: String, userName: String, alias: String, country: String, dob: String){
        
        self.showLoader(message: "LOADING")
        
        let urlPath = kBaseURL + kSignUpAPi
        
        let userDict = ["email"         : "\(emailAddress)",
                        "password"      : "\(password)",
                        "name"          : "\(userName)",
                        "username"      : "\(alias)",
                        "account_type"  : 1,
                        "country"       : "\(country)",
                        "dob"           : dob,
                        "lang"          : "\(getCurrentLanguage())"
            ] as [String : Any]
        
        let requestDict = ["user"      : userDict
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .basic, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(SignupModel.self, from: response?.data ?? Data())
                    setSignupModel(model: data)
                    
                    self.showSuccessView(viewController: self, title: "SUCCESS".localized(), desc: "REGISTER_SUCCESS_DESC".localized(), email: emailAddress, password: password)
                    
//                    self.callAccessTokenApi(emailAddress: emailAddress, password: password)
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: "ALREADY_REGISTERED".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
//    func callAccessTokenApi(emailAddress: String, password: String){
//        self.showLoader(message: "LOADING".localized())
//        let urlPath = kBaseURL + kAccessToken + "?grant_type=password&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&username=" + emailAddress + "&password=" + password + "&account_type=1"
//        
//        Network.shared.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
//            self.hideLoader()
//            if status == .Success{
//                do {
//                    let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())
//
//                    setAccessTokenModel(model: data)
//                    
//                    kAppDelegate.setUpWebSocket()
//                    
//                    self.callSaveDeviceAPI()
//                    
//                } catch let error {
//                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
//                }
//            }else{
//                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
//            }
//        }
//    }
//    
//    func callSaveDeviceAPI(){
//        self.showLoader(message: "LOADING".localized())
//        let urlPath = kBaseURL + kSaveDeviceToken
//
//        let requestDict = ["devise_id" : kAppDelegate.kdeviceIdValueKey,
//                           "firebase_token" : kAppDelegate.kdeviceFCMToken ?? "simulator",
//                           "devise_description" : "iOS"
//        ]
//        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
//            self.hideLoader()
//            
//            self.showSuccessView(viewController: self, title: "SUCCESS".localized(), desc: "REGISTER_SUCCESS_DESC".localized())
//            if status == .Success{
//                print(response)
//            }else{
//                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
//            }
//        }
//    }
//    
}
