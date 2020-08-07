//
//  SelectPreferenceWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 07/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension SelectPreferenceViewController{
    
    func callSearchExpertApi(surveyArray: [String], type: String){
        self.showLoadingScreen()
        var urlPath = ""
        if type == "0"{
            urlPath = kBaseURL + kSearchExpert + "?"
        }else{
            urlPath = kBaseURL + kSearchExpert + "?gender=" + type + "&"
        }

        if self.isOpenFrom == .switchExpert{
            urlPath = urlPath + "&expert_id=" + self.expertId_SwitchExpert + "&"
        }else{

        }

        var surveyString = ""
        if surveyArray.count > 0{
            for i in 0...surveyArray.count - 1{
                surveyString = surveyString + "surveys[]=" + surveyArray[i]
                if i != surveyArray.count - 1{
                    surveyString = surveyString + "&"
                }
            }
        }
    
        urlPath = urlPath + surveyString

        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            if status == .Success{
                if let _ = response!.result.value as? NSDictionary{
                    do {
                        let data = try self.JSONdecoder.decode(ExpertProfileModel.self, from: response?.data ?? Data())
                        self.searchExpertData = data
                        self.callGetPreviousExpertDataAPi()
                    } catch let error {
                        self.hideLoadingScreen(isSuccess: false)
                        self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                    }
                }else{
                    self.searchExpertData = nil
                    self.callGetPreviousExpertDataAPi()
                }
            }else{
                self.hideLoadingScreen(isSuccess: false)
                self.showAlert(viewController: self, alertTitle: "FAILURE".localized() ,alertMessage: message, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callGetPreviousExpertDataAPi(){
        var urlPath = kBaseURL + kGetPreviousExpert
        
        if self.isOpenFrom == .switchExpert{
            urlPath = urlPath + "?expert_id=" + self.expertId_SwitchExpert
        }else{
            
        }
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(PreviousExpertProfileModel.self, from: response?.data ?? Data())
                    let model: PreviousExpertProfileModel = data
                    if model.data!.count > 0{
                        let chooseExpert = surveyStoryboard.instantiateViewController(withIdentifier: "ChooseExpertViewController") as! ChooseExpertViewController
                        chooseExpert.searchExpertProfileData = self.searchExpertData
                        chooseExpert.arrayOfPreviousExpertProfileData = model.data!
                        chooseExpert.selectedSuverArray = self.selectedSuverArray
                        chooseExpert.isOpenFrom = self.isOpenFrom
                        chooseExpert.roomId = self.roomId
                        self.navigationController?.pushViewController(chooseExpert, animated: true)
                    }else{
                        if self.searchExpertData != nil{
                            self.hideLoadingScreen(model: self.searchExpertData, isSuccess: true)
                        }else{
                            self.noExpertFound = true
                            self.hideLoadingScreen(isSuccess: false)
                            self.showAlert(viewController: self, alertTitle: "EXPERT_UNAVAIBALE".localized(), alertMessage: "ALL_EXPERT_OFFLINE".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                        }
                    }
                } catch let error {
                    self.hideLoadingScreen(isSuccess: false)
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.hideLoadingScreen(isSuccess: false)
                self.showAlert(viewController: self, alertTitle: "FAILURE".localized() ,alertMessage: message, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
}
