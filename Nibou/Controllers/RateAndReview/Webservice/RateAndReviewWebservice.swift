//
//  RateAndReviewWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 12/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

extension RateViewController{
    
    func callRateApi(roomId: String, expertId: Int, comment: String, rate: Int){
        
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kRateAndReview
        let requestDict = ["room_id"      : roomId,
                           "expert_id"    : expertId,
                           "comment"      : comment,
                           "value"        : rate
            ] as [String : Any]
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.dismiss(animated: false, completion: {
                    let thanksViewC = commonStoryboard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                    kAppDelegate.window?.rootViewController?.present(thanksViewC, animated: false, completion: nil)
                })

            }else{
                self.isError = true
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
        
    }
    
}
