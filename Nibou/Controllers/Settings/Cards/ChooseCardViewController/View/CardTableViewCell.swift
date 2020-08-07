//
//  CardTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgViewError     : UIImageView!
    @IBOutlet weak var cellBGView       : UIView!
    @IBOutlet weak var lblExpiryDate    : UILabel!
    @IBOutlet weak var lblCardNumber    : UILabel!
    @IBOutlet weak var btnDelete        : UIButton!
    @IBOutlet weak var lblName          : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnDelete.setTitle("DELETE_CARD".localized(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(indexPath: IndexPath, model: CardIncluded){
        self.lblName.text = model.attributes!.card_type!
        self.lblCardNumber.text = "****          ****          ****           " + model.attributes!.last_numbers!
        self.lblExpiryDate.text = "EXP " + model.attributes!.exp_date!

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/yy"
        let expTime = dateFormatter.date(from: model.attributes!.exp_date!)
        
        let currentStr = dateFormatter.string(from: Date())
        let currentTime = dateFormatter.date(from: currentStr)
        
        if expTime! > currentTime!{
            self.imgViewError.isHidden = true
        }else{
             self.imgViewError.isHidden = false
        }
    }
    
}
