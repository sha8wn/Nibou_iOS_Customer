//
//  ExpertProfileWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 10/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

enum ExpertDataType{
    case language
    case expertise
    case timings
}


extension ExpertProfileViewController{
    
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
                self.isError = true
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callGetExpertProfileDataAPI(expertId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetExpertProfile + "/" + "\(expertId)" + "?include=languages,expertises,user_timings"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                let responseDict = response!.result.value as! NSDictionary
                self.expertProfileDict = responseDict
                let dataDict = responseDict.value(forKey: "data") as! NSDictionary
                if dataDict.count > 0{
                    self.getDataArrayFromExpertAPI(profileDict: responseDict)
                    self.callGetListOfReviewsAPI(expertId: expertId)
                    self.tableView.reloadData()
                }else{
                    self.isExpertFound = false
                    self.showAlert(viewController: self, alertMessage: "NO_EXPERT_FOUND".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.isError = true
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callGetListOfReviewsAPI(expertId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetReviewList + "/" + "\(expertId)"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ReviewModel.self, from: response?.data ?? Data())
                    self.setUpReviewModel(model: responseModel)
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.isError = true
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
   
    func setUpReviewModel(model: ReviewModel){
        var reviewModel = Reviews()
        if model.data != nil{
            if model.data!.count > 0{
                for subModel in model.data!{
                    reviewModel.rate = subModel.attributes!.value!
                    reviewModel.desc = subModel.attributes!.comment!
                    reviewModel.date = subModel.attributes!.created_at!
                    reviewModel.senderId = subModel.relationships!.customer!.data!.id!
                    self.arrayReview.append(reviewModel)
                }
            }
        }
        if self.arrayReview.count > 0{
            for i in 0...self.arrayReview.count - 1{
                var mainModel = self.arrayReview[i]
                if model.included != nil{
                    if model.included!.count > 0{
                        for subModel in model.included!{
                            if subModel.id! == mainModel.senderId!{
                                mainModel.name = subModel.attributes!.username!
                            }
                        }
                        self.arrayReview[i] = mainModel
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    func getDataArrayFromExpertAPI(profileDict: NSDictionary){
        if let includedArray = profileDict.value(forKey: "included") as? NSArray{
            if includedArray.count > 0{
                for i in 0...includedArray.count - 1{
                    if let subDict = includedArray[i] as? NSDictionary{
                        if let attributeDict = subDict.value(forKey: "attributes") as? NSDictionary{
                            if let includedtype = subDict.value(forKey: "type") as? String{
                                if includedtype == "languages"{
                                    if let title = attributeDict.value(forKey: "title") as? String{
                                        self.arrayLanguage.append(title)
                                    }
                                }else if includedtype == "expertises"{
                                    if let title = attributeDict.value(forKey: "title") as? String{
                                        self.arrayExpertises.append(title)
                                    }
                                }else if includedtype == "user_timings"{
                                    
                                    var model = Timings()
                                    
                                    let weekDays = ["MONDAY".localized(), "TUESDAY".localized(), "WEDNESDAY".localized(), "THRUSDAY".localized(), "FRIDAY".localized(), "SATURDAY".localized(), "SUNDAY".localized()]
                                    
                                    if let dayNumber = attributeDict.value(forKey: "day_number") as? Int{
                                        model.day = weekDays[dayNumber - 1]
                                        
                                        let startTime = attributeDict.value(forKey: "time_from") as! String
                                        let endTime = attributeDict.value(forKey: "time_to") as! String
                                        
                                        let timedateFormatter24h = DateFormatter()
                                        timedateFormatter24h.dateFormat = "HH:mm"
                                        let start24h = timedateFormatter24h.date(from: startTime)
                                        
                                        let end24h = timedateFormatter24h.date(from: endTime)
                                        
                                        
                                        let timedateFormatter = DateFormatter()
                                        timedateFormatter.dateFormat = "HH:mm"
//                                        timedateFormatter.dateFormat = "h:mm a"
                                        let timeA = timedateFormatter.string(from: start24h ?? Date())
                                        
                                        let timeB = timedateFormatter.string(from: end24h ?? Date())
                                        
                                        model.time = timeA + " - " + timeB
                                        
                                    }
                                    
                                    self.arrayTimings.append(model)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

