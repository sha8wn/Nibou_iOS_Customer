//
//  ChooseCardWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 08/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension ChooseCardViewController{
    
    
    func callGetCardList(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetProfile  + "?include=user_credit_cards"
        
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
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
                        }
                    }else{
                        
                    }
                    
                    if self.cardModel.count > 0{
                        self.lblNoCard.isHidden = true
                    }else{
                        self.lblNoCard.isHidden = false
                        self.lblNoCard.text = "NO_DATA_FOUND".localized()
                    }
                    self.tableView.reloadData()
                } catch let error {
                    self.showAlert(viewController: self, alertTitle: "", alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callDeleteCardApi(cardId: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kDeleteCard  + cardId
        Network.shared.request(urlPath: urlPath, methods: .delete, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.cardId = ""
                self.callGetCardList()
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callMakeCardDefaultAPi(id: String){
        self.showLoader(message: "LOADING".localized())
        var urlPath: String = kBaseURL + kCardDefault
        urlPath = String(format: urlPath, id)
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.cardId = ""
                self.showAlert(viewController: self,alertTitle: "SUCCESS".localized() , alertMessage: "CARD_DEFAULT_SUCCESS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                self.btnSetDefault.isHidden = true
                self.btnSetDefaultHeightCons.constant = 0
//                self.btnSetDefault.setTitle("SELECT_CARD".localized(), for: .normal)
                self.callGetCardList()
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
