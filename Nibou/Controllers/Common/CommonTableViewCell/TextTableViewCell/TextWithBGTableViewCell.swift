//
//  TextWithBGTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TextWithBGTableViewCell: UITableViewCell {

    @IBOutlet weak var txtField     : CustomTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
