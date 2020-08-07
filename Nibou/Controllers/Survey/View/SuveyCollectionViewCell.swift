//
//  SuveyCollectionViewCell.swift
//  Nibou
//
//  Created by Ongraph on 5/13/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class SuveyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var btnTitle: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnTitle.layer.cornerRadius = 6
        self.btnTitle.layer.borderColor = UIColor.white.cgColor
        self.btnTitle.layer.borderWidth = 1
        // Initialization code
    }

    func configureCell(array: [Bool], index: Int, dataArray: [String]){
        self.btnTitle.setTitle(dataArray[index], for: .normal)
        if index == array.count - 1{
            if array[index] == true{
                self.btnTitle.setTitleColor(UIColor.headerBlueColor(), for: .normal)
                self.btnTitle.layer.borderColor = UIColor.white.cgColor
                self.btnTitle.backgroundColor = UIColor.white
            }else{
                self.btnTitle.setTitleColor(UIColor.white, for: .normal)
                self.btnTitle.layer.borderColor = UIColor.clear.cgColor
                self.btnTitle.backgroundColor = UIColor.clear
            }
        }else{
            if array[index] == true{
                self.btnTitle.setTitleColor(UIColor.headerBlueColor(), for: .normal)
                self.btnTitle.layer.borderColor = UIColor.white.cgColor
                self.btnTitle.backgroundColor = UIColor.white
            }else{
                self.btnTitle.setTitleColor(UIColor.white, for: .normal)
                self.btnTitle.layer.borderColor = UIColor.white.cgColor
                self.btnTitle.backgroundColor = UIColor.clear
            }
        }
    }
}
