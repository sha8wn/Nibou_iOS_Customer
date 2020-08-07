//
//  TransactionHistoryViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit


enum NBEarningViewType{
    case month
    case day
}

class TransactionHistoryViewController: BaseViewController {

    //MARK:- Properties
    @IBOutlet weak var btn_back                 : UIButton!
    @IBOutlet weak var lbl_header               : UILabel!
    @IBOutlet weak var lbl_NoData               : UILabel!
    @IBOutlet weak var table_view               : UITableView!
    @IBOutlet weak var cons_heightForTableview  : NSLayoutConstraint!
    var viewType                                : NBEarningViewType!
    var monthEarningModel                       : [PaymentOverallData]  = []
    var dayEarningModel                         : [DayEarningData]      = []
    var selectedDate                            : String                = ""
    var totalRecord                             : Int                   = 0
    var pageNumber                              : Int                   = 1
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.setup()
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.table_view.separatorStyle = .none
        self.lbl_NoData.text = "NO_DATA_FOUND".localized()
        self.table_view.register(UINib(nibName: "TransactionHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionHistoryTableViewCell")
        self.table_view.register(UINib(nibName: "NBEarningDayTableViewCell", bundle: nil), forCellReuseIdentifier: "NBEarningDayTableViewCell")
        if self.viewType == .month{
            self.lbl_header.text = "T_HEADER".localized()
            self.cons_heightForTableview.constant = 0
            self.table_view.needsUpdateConstraints()
//            self.callGetMonthPerDayPaymentAPI()
            self.callGetOverallDayPaymentAPI(page: 1)
        }else{
            self.lbl_header.text = ""
            self.cons_heightForTableview.constant = (kScreenHeight - self.table_view.frame.origin.y - 20)
            self.table_view.needsUpdateConstraints()
            self.callGetDayPaymentAPI(page: 1, date: self.selectedDate)
        }
    }
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - TableView Delegate and DataSource
extension TransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewType == .month{
            if self.monthEarningModel != nil && self.monthEarningModel.count > 0{
                return self.monthEarningModel.count
            }else{
                return 0
            }
        }else{
            if self.dayEarningModel.count > 0{
                return self.dayEarningModel.count
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.viewType == .month{
            return 80
        }else{
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewType == .month{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "TransactionHistoryTableViewCell", for: indexPath) as! TransactionHistoryTableViewCell
            cell.selectionStyle = .none
            
            let model = self.monthEarningModel[indexPath.row]
            
            //AMOUNT
            cell.lblPrice.text = "₺ " + String(model.attributes!.amount ?? 0)
            
            //TIME IN MINS
            let totalSec = model.attributes!.total_seconds ?? 0
            let sec = totalSec / 60
//            let totalMin = Int(sec) % 60
            let totalMin = Int(sec)
            cell.lblTime.text = String(totalMin) + " " + "MINS".localized()
            
            //DATE
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from: model.attributes!.date_at!)
            cell.lblDate.text = "\(convertDateFormater(date: date!, format:"dd MMMM yyyy"))"
            
            self.table_view.separatorColor = UIColor.clear
            self.table_view.tableFooterView = UIView()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "NBEarningDayTableViewCell", for: indexPath) as! NBEarningDayTableViewCell
            let model = self.dayEarningModel[indexPath.row]
            cell.setup(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewType == .month{
            let model = self.monthEarningModel[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            let date = dateFormatter.date(from: model.attributes!.date_at!)
            let strDate = "\(convertDateFormater(date: date!, format:"dd-MM-yyyy"))"
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
            viewController.viewType = .day
            viewController.selectedDate = strDate
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension TransactionHistoryViewController: AlertDelegate{
    
}

//MARK: - UIScrollView Delegate
extension TransactionHistoryViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.viewType == .month{
            if(self.monthEarningModel.count > 0){
                if self.totalRecord == 10
                {
                    self.pageNumber = self.pageNumber + 1
                    self.callGetOverallDayPaymentAPI(page: self.pageNumber)
                }
            }
        }else{
            if(self.dayEarningModel.count > 0){
                if self.totalRecord > self.dayEarningModel.count{
                    self.pageNumber = self.pageNumber + 1
                    self.callGetDayPaymentAPI(page: self.pageNumber, date: self.selectedDate)
                }
            }
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if(self.dayEarningModel.count > 0){
//            if self.totalRecord > self.dayEarningModel.count{
//                self.pageNumber = self.pageNumber + 1
//                self.callGetDayPaymentAPI(page: self.pageNumber)
//            }
//        }
//    }
}
// end
