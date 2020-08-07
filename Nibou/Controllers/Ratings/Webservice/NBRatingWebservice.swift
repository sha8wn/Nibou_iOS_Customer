//
//  NBRatingWebservice.swift
//  Nibou
//
//  Created by Himanshu Goyal on 25/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation

extension NBRatingsVC{
    
    func callGetListOfReviewsAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetReviewList + "/" + "\(self.expertId)"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(ReviewModel.self, from: response?.data ?? Data())
                    self.setUpModel(model: responseModel)
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}

//struct Reviews{
//    var name: String?
//    var date: String?
//    var rate: Int?
//    var desc: String?
//    var senderId: String?
//}
