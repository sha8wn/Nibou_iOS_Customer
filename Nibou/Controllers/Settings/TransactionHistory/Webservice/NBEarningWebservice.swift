//
//  EarningModel.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//
import Foundation
import UIKit

extension TransactionHistoryViewController{

    func callGetDayPaymentAPI(page: Int, date: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetDayPayment + "day=" + "\(date)" + "&payed=true&page[number]=" + "\(page)" + "&page[size]=10"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(DayEarningModel.self, from: response?.data ?? Data())
                    if responseModel.data != nil{
                        self.lbl_NoData.isHidden = true
                        self.totalRecord = responseModel.meta!.total_count ?? 0
                        self.dayEarningModel = self.dayEarningModel + responseModel.data!
                        if self.dayEarningModel.count > 0{
                            self.lbl_NoData.isHidden = true
                        }else{
                            self.lbl_NoData.isHidden = false
                        }
                        self.table_view.reloadData()
                    }else{
                        self.lbl_NoData.isHidden = false
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callGetOverallDayPaymentAPI(page: Int){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetOverallDay + "payed=true&page[number]=" + "\(page)" + "&page[size]=10"
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let responseModel = try self.JSONdecoder.decode(EarningMonthModel.self, from: response?.data ?? Data())
                    if responseModel.data != nil{
                        self.totalRecord = responseModel.data!.count
                        self.lbl_NoData.isHidden = true
                        self.monthEarningModel = self.monthEarningModel + responseModel.data!
                        if self.monthEarningModel.count > 0{
                            let totalTableHeight = (kScreenHeight - self.table_view.frame.origin.y - 20)
                            if totalTableHeight < CGFloat(80 * self.monthEarningModel.count){
                                 self.cons_heightForTableview.constant = totalTableHeight
                            }else{
                                 self.cons_heightForTableview.constant = CGFloat(80 * self.monthEarningModel.count)
                            }
                            self.table_view.needsUpdateConstraints()
                            self.table_view.reloadData()
                        }else{
                            self.lbl_NoData.isHidden = false
                        }
                    }else{
                        self.lbl_NoData.isHidden = false
                    }
                } catch let error {
                    print(error.localizedDescription)
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    
    
//    func callGetMonthPerDayPaymentAPI(){
//        self.showLoader(message: "LOADING".localized())
//        let urlPath = kBaseURL + kGetMonthPerDayPayment + "\(getFirstDayOfCurrentMonth())"
//        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
//            self.hideLoader()
//            if status == .Success{
//                do {
//                    let responseModel = try self.JSONdecoder.decode(EarningMonthModel.self, from: response?.data ?? Data())
//                    if responseModel.data != nil{
//                        self.lbl_NoData.isHidden = true
//                        self.monthEarningModel = responseModel
//                        if responseModel.data!.count > 0{
//                            self.cons_heightForTableview.constant = CGFloat(80 * responseModel.data!.count)
//                            self.table_view.needsUpdateConstraints()
//                            self.table_view.reloadData()
//                        }else{
//                            self.lbl_NoData.isHidden = false
//                        }
//                    }else{
//                        self.lbl_NoData.isHidden = false
//                    }
//                } catch let error {
//                    print(error.localizedDescription)
//                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
//                }
//            }else{
//                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
//            }
//        }
//    }
//
//    func callGetDayPaymentAPI(page: Int){
//        self.showLoader(message: "LOADING".localized())
//        let urlPath = kBaseURL + kGetDayPayment + "payed=true&page[number]=" + "\(page)" + "&page[size]=10"
//        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) { (response, message, statusCode, status) in
//            self.hideLoader()
//            if status == .Success{
//                do {
//                    let responseModel = try self.JSONdecoder.decode(DayEarningModel.self, from: response?.data ?? Data())
//                    if responseModel.data != nil{
//                        self.lbl_NoData.isHidden = true
//                        self.totalRecord = responseModel.meta!.total_count ?? 0
//                        self.dayEarningModel = self.dayEarningModel + responseModel.data!
//                        if self.dayEarningModel.count > 0{
//                            self.lbl_NoData.isHidden = true
//                        }else{
//                            self.lbl_NoData.isHidden = false
//                        }
//                        self.table_view.reloadData()
//                    }else{
//                        self.lbl_NoData.isHidden = false
//                    }
//                } catch let error {
//                    print(error.localizedDescription)
//                    self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
//                }
//            }else{
//                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
//            }
//        }
//    }
//

    
    func getFirstDayOfCurrentMonth() -> String{
        let calendar = Calendar.current
        let firstDayComponents = calendar.dateComponents([.year, .month], from: Date())
        let firstDay = calendar.date(from: firstDayComponents)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_UK")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: firstDay)
        
        return date
    }

}
