//
//  HeaderWithTitleAndDescTableViewCell.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class HeaderWithTitleAndDescTableViewCell: UITableViewCell {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UITextView!
    
    //end
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
