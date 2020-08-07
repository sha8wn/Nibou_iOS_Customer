//
//  ProfileWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 28/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension ProfileViewController{
    
    //MARK: - GET PROFILE DATA
    func callGetProfileApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    
                    if let userName = responseModel.data!.attributes!.name {
                        self.strUserName = userName
                    }else{
                        self.strUserName = ""
                    }
                    
                    
                    if let alias = responseModel.data!.attributes!.username {
                         self.strAlias = alias
                    }else{
                         self.strAlias = ""
                    }
                   
                    
                    if let email = responseModel.data!.attributes!.email{
                         self.strEmailAddress = email
                    } else{
                         self.strEmailAddress = ""
                    }
                   
                    
                    if let country = responseModel.data!.attributes!.country{
                        self.strCountry = country
                    } else{
                        self.strCountry = ""
                    }
                    
                    
                    if let dob = responseModel.data!.attributes!.dob {
                        self.strDOB = dob
                    }else{
                        self.strDOB = ""
                    }
                   
                    
                    self.tableView.reloadData()
                    
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
    
    //MARK: - UPDATE PROFILE DATA
    func callUpdateProfileApi(userName: String, country: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateProfile
        
        let requestDict = ["name"           : "\(userName)",
                           "country"        : "\(country)"
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    self.isEditSuccessfully = true
                    self.showAlert(viewController: self,alertTitle: "SUCCESS".localized(), alertMessage: "PROFILE_UPDATE_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())

                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                if statusCode == 400{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INVALID_LOGIN".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }
    }
    
}

