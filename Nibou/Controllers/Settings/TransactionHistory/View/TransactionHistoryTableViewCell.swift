//
//  TransactionHistoryTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TransactionHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime      : UILabel!
    @IBOutlet weak var lblDate      : UILabel!
    @IBOutlet weak var lblPrice     : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
