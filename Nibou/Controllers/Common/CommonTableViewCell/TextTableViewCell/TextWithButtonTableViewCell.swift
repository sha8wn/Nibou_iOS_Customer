//
//  TextWithButtonTableViewCell.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TextWithButtonTableViewCell: UITableViewCell {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var txtField     : CustomTextField!
    @IBOutlet weak var button       : UIButton!
    
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
