//
//  HomeWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 10/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

extension HomeViewController{
    
    func callGetChatSessionApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kChatSession
       
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) {
            (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(HomeModel.self, from: response?.data ?? Data())
                    self.homeModel = data
                
                    if self.homeModel != nil{
                        if self.homeModel.data != nil{
                            if self.homeModel.data!.count > 0{
                                var emptyLastMessageModel: [HomeData] = []
                                var tempModel: [HomeData] = []
                                for model in self.homeModel.data!{
                                    if let _ = model.attributes!.last_message{
                                        tempModel.append(model)
                                    }else{
                                        emptyLastMessageModel.append(model)
                                    }
                                }
                                tempModel.sort { ($0 as HomeData).attributes!.last_message!.data!.attributes!.created_at! > ($1 as HomeData).attributes!.last_message!.data!.attributes!.created_at! }
                                let newArrayModel = emptyLastMessageModel + tempModel
                                self.homeModel.data = newArrayModel
                            }
                        }
                    }

                    if self.homeModel.data!.count > 0{
                        var arrayNewMessage = getNewMessageData()
                        arrayNewMessage.sort{ ($0["newMessageCount"] as! Int) > ($1["newMessageCount"] as! Int) }
                        print(arrayNewMessage)
                        for newMessageDict in arrayNewMessage{
                            if self.homeModel != nil{
                                if self.homeModel.data!.count > 0{
                                    for i in 0...self.homeModel.data!.count - 1{
                                        var model = self.homeModel.data![i]
                                        print(model)
                                        if model.id! == newMessageDict["roomId"] as! String{
                                            model.newMessageCount = newMessageDict["newMessageCount"] as? Int
                                            model.lastMessageTimestamp = newMessageDict["lastMessageTimestamp"] as? String
                                            self.homeModel.data![i] = model
                                        }else{
                                        }
                                    }
                                }else{
                                }
                            }else{
                            }
                        }
                        if self.homeModel != nil{
                            if self.homeModel.data!.count > 0{
                                self.homeModel.data!.sort{ (($0 as HomeData).lastMessageTimestamp ?? "") > (($1 as HomeData).lastMessageTimestamp ?? "") }
                            }
                        }
                    }else{
                    }
                    self.tableView.reloadData()
                    self.callGetProfileApi()
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    //MARK: - GET PROFILE DATA
    func callGetProfileApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile + "?include=user_credit_cards"
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    setProfileModel(model: responseModel)
                    
                    let profileModel = getProfileModel()
                    if profileModel != nil{
                        
                        self.lblTitle.text = String(format: "HOME_TITLE".localized(), profileModel!.data!.attributes!.name!)
                        
//                        self.lblTitle.text = "Hello, " + profileModel!.data!.attributes!.name!
                    }
                    
                    do {
                        let responseModel = try self.JSONdecoder.decode(CardListModel.self, from: response?.data ?? Data())
                        if responseModel.included != nil{
                            if responseModel.included!.count > 0{
                                self.cardModel = responseModel.included!
                                for i in 0...responseModel.included!.count - 1{
                                    var model = responseModel.included![i]
                                    if model.attributes!.is_active == true{
                                        model.isSelected = true
                                        self.cardModel.remove(at: i)
                                        self.cardModel.insert(model, at: 0)
                                    }else{
                                        
                                    }
                                }
                                self.haveValidCard = self.isUserHaveValidCard()
                            }else{
                                self.haveValidCard = false
                            }
                        }else{
                            self.haveValidCard = false
                        }
                    } catch let error {
                        self.showAlert(viewController: self, alertTitle: "", alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                    }
                    
                } catch let error {
                    self.showAlert(viewController: self, alertTitle: error.localizedDescription, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func isUserHaveValidCard() -> Bool{
        
        var isValidCard: Bool = false
        for i in 0...self.cardModel.count - 1{
            let model = self.cardModel[i]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm/yy"
            let expTime = dateFormatter.date(from: model.attributes!.exp_date!)
            
            let currentStr = dateFormatter.string(from: Date())
            let currentTime = dateFormatter.date(from: currentStr)
            
            if expTime! > currentTime!{
                isValidCard = true
            }else{
                
            }
        }
        return isValidCard
    }
    
}
