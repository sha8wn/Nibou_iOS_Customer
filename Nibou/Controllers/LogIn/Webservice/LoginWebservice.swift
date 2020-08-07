//
//  LoginWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 27/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension LogInViewController{
    
    func callAccessTokenApi(emailAddress: String, password: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kAccessToken + "?grant_type=password&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&username=" + emailAddress + "&password=" + password + "&account_type=1"
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())

                    setAccessTokenModel(model: data)
                    
                    kAppDelegate.setUpWebSocket()
                    self.callSaveDeviceAPI()
                    
                    
                    
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    func callGetChatSessionApi(completion:@escaping (_ isOpenHome: Bool) -> Void){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatSession
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) {
            (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let model = try self.JSONdecoder.decode(HomeModel.self, from: response?.data ?? Data())
                    if model.data!.count > 0{
                        completion(true)
                    }else{
                        completion(false)
                    }
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                    completion(false)
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
                completion(false)
            }
        }
    }
    
    func callSaveDeviceAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kSaveDeviceToken
        
        let requestDict = ["devise_id" : kAppDelegate.kdeviceIdValueKey,
                           "firebase_token" : kAppDelegate.kdeviceFCMToken ?? "simulator",
                           "devise_description" : "iOS"
        ]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            self.callGetChatSessionApi(completion: { (isOpenHome) in
                if isOpenHome{
                    let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }else{
                    let surveyVC = surveyStoryboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
                    surveyVC.isOpenFrom = .login
                    self.navigationController?.pushViewController(surveyVC, animated: true)
                }
            })
            
            if status == .Success{
                print(response)
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
