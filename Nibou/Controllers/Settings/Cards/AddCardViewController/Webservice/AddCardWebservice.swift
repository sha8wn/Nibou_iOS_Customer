//
//  AddCardWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 08/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension AddCardViewController{
    
    func createPayment(token: String, amount: Float) {
        self.showLoader(message: "LOADING".localized())
        let HttpHeaders = ["Authorization": "Bearer \(kStripeMerchantIdentifier)"
        ]
        
        var url = ""
        let baseUrl = "https://api.stripe.com/v1/charges?"
        let amountStr = "amount=" + "\(Int(amount))"
        let currency = "&currency=usd&description=AddingNewCard"
        let source = "&customer=" + "\(token)"
        url = baseUrl + amountStr + currency + source
        
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HttpHeaders).responseJSON { (responseObject) -> Void in
            
            let (status, statusCode, message, _) = handleError(response: responseObject)
            
            guard let resJson = responseObject.result.value as? NSDictionary else { return }
            print("Reponse: ", resJson)
            print("StatusCode: ", statusCode)
            print("---------------------")
            
            self.hideLoader()
            
            if status == .Success{
                guard let chargeId = resJson.value(forKey: "id") as? String else{ return }
                
                guard let sourceDict = resJson.value(forKey: "source") as? NSDictionary else { return }
                
                guard let brand = sourceDict.value(forKey: "brand") as? String else { return }
                
                guard let card_id = sourceDict.value(forKey: "id") as? String else { return }
                
                self.cardId = card_id
                
                self.strCardType = brand
                
                self.refundPayment(token: token, chargeId: chargeId)
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    
    func refundPayment(token: String, chargeId: String) {
        self.showLoader(message: "LOADING".localized())
        let HttpHeaders = ["Authorization": "Bearer \(kStripeMerchantIdentifier)"
        ]
        
        var url = ""
        let baseUrl = "https://api.stripe.com/v1/refunds?"
        let id = "charge=" + "\(chargeId)"
        
        url = baseUrl + id
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HttpHeaders).responseString {
            response in
            
            self.hideLoader()
            switch response.result {
            case .success:
                
                print(response)
                print("Success")
                
                self.callAddCardAPI(card_type: self.strCardType, last_numbers: self.strCardLastDigit, exp_date: self.txtExpiryDate.text!, card_id: self.cardId, customer_id: self.customerId)
                
                break
            case .failure( _):
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callCreateCustomerAPi(token: String){
        self.showLoader(message: "LOADING".localized())
        let HttpHeaders = ["Authorization": "Bearer \(kStripeMerchantIdentifier)"
        ]
        var urlPath = ""
        let baseUrl = "https://api.stripe.com/v1/customers?"
        let descStr = "description=" + "\(getLoggedInUserId())"
        let source = "&source=" + "\(token)"
        urlPath = baseUrl + descStr + source
        
        Alamofire.request(urlPath, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: HttpHeaders).responseJSON { (responseObject) -> Void in
            
            let (status, statusCode, message, _) = handleError(response: responseObject)
            
            guard let resJson = responseObject.result.value as? NSDictionary else { return }
            print("Reponse: ", resJson)
            print("StatusCode: ", statusCode)
            print("Message: ", message)
            print("---------------------")

            self.hideLoader()
            if status == .Success{
                
                guard let customerId = resJson.value(forKey: "id") as? String else { return }
                
                self.customerId = customerId
                
//                self.setupStripe(type: "Charge")
                self.createPayment(token: self.customerId, amount: 100)

            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callAddCardAPI(card_type: String, last_numbers: String, exp_date: String, card_id: String, customer_id: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kAddCard
        
        let requestDict = ["card_type"       : card_type,
                           "last_numbers"    : last_numbers,
                           "card_id"         : card_id,
                           "exp_date"        : exp_date,
                           "customer_id"     : customer_id,
                           "is_default"      : true
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            if status == .Success{
                print(response)
                self.isCardAddedSuccessfully = true
                self.showAlert(viewController: self, alertTitle: "SUCCESS".localized(), alertMessage:  "CARD_ADDED_SUCCESSFULLY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
}
