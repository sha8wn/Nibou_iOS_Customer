//
//  NBRightMessageTableCell.swift
//  Nibou
//
//  Created by Ongraph on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBRightMessageTableCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var view_border: UIView!
    @IBOutlet weak var lbl_text: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //textView.textContainerInset = UIEdgeInsetsMake(10, 0, 10, 0);

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
