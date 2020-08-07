//
//  File.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/09/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension LaunchViewController{
    
    func callSplashScreenApi(completion:@escaping (_ status: WebServiceResponseType) -> Void){
        
        let urlPath = kBaseURL + kUpdateProfile
        
        let requestDict = ["timezone"           : "\(TimeZone.current.identifier)",
            ] as [String : Any]
        
        
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            
            if status == .Success{
                do {
                    let JSONdecoder = JSONDecoder()
                    let responseModel = try JSONdecoder.decode(ProfileModel.self, from: response?.data ?? Data())
                    setProfileModel(model: responseModel)
                    completion(status)
                } catch let error {
                    completion(status)
                    print(error.localizedDescription)
                }
            }else{
                completion(.Failure)
                self.showAlert(viewController: self,alertTitle: "SYSTEM_ERROR".localized(), alertMessage: "SYSTEM_ERROR_DESC".localized(), alertType: .oneButton, singleButtonTitle: "TRY_AGAIN".localized())
            }
        }
    }
    
    func callGetChatSessionApi(){
        let urlPath = kBaseURL + kChatSession
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) {
            (response, message, statusCode, status) in
            if status == .Success{
                do {
                    let JSONdecoder = JSONDecoder()
                    let model = try JSONdecoder.decode(HomeModel.self, from: response?.data ?? Data())
                    if model.data!.count > 0{
                        self.isOpenHome = true
                    }else{
                        self.isOpenHome = false
                    }
                } catch _ {
                    self.isOpenHome = false
                }
                self.setUp()
            }else{
//                self.isOpenHome = false
//                self.setUp()
                self.showAlert(viewController: self,alertTitle: "SYSTEM_ERROR".localized(), alertMessage: "SYSTEM_ERROR_DESC".localized(), alertType: .oneButton, singleButtonTitle: "TRY_AGAIN".localized())
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
                            
                            if self.haveValidCard == true{

                                let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
                                
                                if self.willOpen == "TabbarViewController"{
                                    let rootViewController: TabbarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                                    navigationController.viewControllers = [rootViewController]
                                    navigationController.navigationBar.isHidden = true
                                    kAppDelegate.window?.rootViewController = navigationController
                                }else if self.willOpen == "SurveyViewController"{
                                    let rootViewController: SurveyViewController = surveyStoryboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
                                    rootViewController.isOpenFrom = .appDelegate
                                    navigationController.viewControllers = [rootViewController]
                                    navigationController.navigationBar.isHidden = true
                                    kAppDelegate.window?.rootViewController = navigationController
                                }
                            }else{
                                let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
                                cardVC.cardDelegate = self
                                cardVC.isComeFrom = "Launch"
                                self.present(cardVC, animated: true, completion: nil)
                            }
                            
                        }else{
                            self.haveValidCard = false
                            let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
                            cardVC.cardDelegate = self
                            cardVC.isComeFrom = "Launch"
                            self.present(cardVC, animated: true, completion: nil)
                        }
                    }else{
                        self.haveValidCard = false
                        let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
                        cardVC.cardDelegate = self
                        cardVC.isComeFrom = "Launch"
                        self.present(cardVC, animated: true, completion: nil)
                    }
                } catch let error {
                    self.isError = true
                    self.showAlert(viewController: self, alertTitle: "", alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                
                self.isError = true
                self.showAlert(viewController: self,alertTitle: "ERROR".localized(), alertMessage: "SYSTEM_ERROR_DESC".localized(), alertType: .oneButton, singleButtonTitle: "TRY_AGAIN".localized())
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


