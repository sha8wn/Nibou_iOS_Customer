//
//  TimingsCollectionViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 26/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TimingsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bgView       : UIView!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var lblTiming    : UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Setup Cell
    func setUpCell(index: Int, dict: Timings){
        self.lblTitle.text = dict.day ?? ""
        self.lblTiming.text = dict.time ?? ""
    }
}
