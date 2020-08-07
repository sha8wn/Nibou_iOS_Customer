//
//  EPReviewCollectionViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class EPReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblDate              : UILabel!
    @IBOutlet weak var ratingView           : FloatRatingView!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var lblTitle             : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK:- Setup Cell
    func setUpCell(index: Int, model: Reviews){
        ratingView.backgroundColor = UIColor.clear
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .halfRatings
        ratingView.isUserInteractionEnabled = false
        lblDesc.text = model.desc ?? ""
        lblTitle.text = model.name ?? ""
        ratingView.rating = Double(model.rate ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: model.date!)
        lblDate.text = "\(convertDateFormater(date: date!, format: "EEEE, dd MMM"))"
    }
    
}
