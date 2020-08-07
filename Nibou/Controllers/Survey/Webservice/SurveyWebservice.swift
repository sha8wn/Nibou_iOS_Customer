//
//  SurveyWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 06/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension SurveyViewController{
    
    func callGetSurveyDataApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetSurveyList
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let dataModel = try self.JSONdecoder.decode(SurveyModel.self, from: response?.data ?? Data())
                    
                    if let arrayData = dataModel.data{
                        self.modelArray = arrayData
                        if arrayData.count > 0{
                            for i in 0...arrayData.count - 1{
                                let strTitle = arrayData[i].attributes!.title!
                                self.selectedCellArray.append(false)
                                self.dataArray.append(strTitle)
                            }
                        }
                    }
                    self.dataArray.append("+")
                    self.selectedCellArray.append(false)
                    self.collectionView.reloadData()
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callAddSurveyApi(title: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kUpdateSurveyList
        
        let requestDict = ["title"      : title
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let dataModel = try self.JSONdecoder.decode(AddSurveyModel.self, from: response?.data ?? Data())
                    
                    if let data = dataModel.data{
                        self.modelArray.append(data)
                    }
                    let index = self.dataArray.count - 1
                    self.dataArray[index] = title
                    self.selectedCellArray[index] = true
                    if self.checkNumberOfSelectedItem() < 3{
                        self.dataArray.append("+")
                        self.selectedCellArray.append(false)
                    }else{
                        
                    }
                    
                    self.collectionView.reloadData()
                    
                    if self.checkNumberOfSelectedItem() > 0{
                        self.btnContinue.isHidden = false
                    }else{
                        self.btnContinue.isHidden = true
                    }
                    
//                    self.isAddedNewSurveySuccess = true
//                    self.showAlert(viewController: self, alertTitle: "SUCCESS".localized(), alertMessage: "ADDED_SURVEY_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callLogOutApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kLogOut
        let requestDict = ["available": false] as [String : Any]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            //Unsubscribe to Socket
            kAppDelegate.notficationChannel.unsubscribe()
            kAppDelegate.webClient.disconnect()
            
            //Clear UserDefault
            clearUserDefault()
            
            //Open Login Screen
            let userTypeVC = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(userTypeVC, animated: true)
        }
    }
}


