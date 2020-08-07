//
//  NBEarningDayTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 14/08/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBEarningDayTableViewCell: UITableViewCell {

    @IBOutlet weak var lblType                  : UILabel!
    @IBOutlet weak var lblStaticType            : UILabel!
    @IBOutlet weak var lblDate                  : UILabel!
    @IBOutlet weak var lblStaticDate            : UILabel!
    @IBOutlet weak var lblStaticTransactionId   : UILabel!
    @IBOutlet weak var lblTransactionId         : UILabel!
    @IBOutlet weak var lblRoom                  : UILabel!
    @IBOutlet weak var lblStaticRoom            : UILabel!
    @IBOutlet weak var lblAmount                : UILabel!
    @IBOutlet weak var lblStaticAmount          : UILabel!
    @IBOutlet weak var lblTime                  : UILabel!
    @IBOutlet weak var lblStaticTime            : UILabel!
    @IBOutlet weak var lblUser                  : UILabel!
    @IBOutlet weak var lblStaticUser            : UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model: DayEarningData){
        
        //USER
        self.lblStaticUser.text = "T_EXPERT_NAME".localized()
        if model.attributes!.room!.data!.attributes!.users!.count > 0{
            for i in 0...model.attributes!.room!.data!.attributes!.users!.count - 1{
                let userModel = model.attributes!.room!.data!.attributes!.users![i].data!
                if userModel.id == "\(getLoggedInUserId())"{
                    
                }else{
                    self.lblUser.text = userModel.attributes!.username!
                }
            }
        }
        
        //TIME
        self.lblStaticTime.text = "T_TIME".localized()
        
        let totalSec = model.attributes!.total_seconds ?? 0
        let sec = totalSec / 60
//        let totalMin = Int(sec) % 60
        let totalMin = Int(sec)
        self.lblTime.text = String(totalMin) + " " + "MINS".localized()
        
        //AMOUNT
        self.lblStaticAmount.text = "T_AMOUNT".localized()
        self.lblAmount.text = "₺ " +  String(model.attributes!.amount!.stringWithoutZeroFraction)
        
        //TRANSACTION ID
        self.lblStaticTransactionId.text = "T_TRANSACTION_ID".localized()
        self.lblTransactionId.text = model.id
        
        //DATE
        self.lblStaticDate.text = "T_DATE".localized()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: model.attributes!.created_at!)
        self.lblDate.text = "\(convertDateFormater(date: date!, format:"dd MMMM, yyyy"))"
        
        //ROOM
        var room: String = ""
        if let _ = model.attributes!.room!.data!.attributes!.expertises{
            for i in 0...model.attributes!.room!.data!.attributes!.expertises!.count - 1{
                let subModel = model.attributes!.room!.data!.attributes!.expertises![i]
                if model.attributes!.room!.data!.attributes!.expertises!.count > 1{
                    if i == 0{
                        room = subModel.data!.attributes!.title!
                    }else{
                        room = room + ", " + subModel.data!.attributes!.title!
                    }
                }else{
                    room = subModel.data!.attributes!.title!
                }
            }
        }else{
        }
        self.lblStaticRoom.text = "T_ROOM".localized()
        self.lblRoom.text = room
        
        //Type
        var payed: Bool = false
        if let type = model.attributes!.payed{
            payed = type
        }else{
            payed = false
        }
        DispatchQueue.main.async {
            if payed{
                self.lblStaticType.backgroundColor = UIColor(named: "Paid_Color")
                self.lblType.textColor = UIColor(named: "Paid_Color")
                self.lblType.text = "T_PAID".localized()
            }else{
                self.lblStaticType.backgroundColor = UIColor(named: "Unpaid_Color")
                self.lblType.textColor = UIColor(named: "Unpaid_Color")
                self.lblType.text = "T_UNPAID".localized()
            }
        }
        
    
        print(model)
    }
    
}

