//
//  NBRatingTableCell.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBRatingTableCell: UITableViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_month: UILabel!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var rating_view: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Setup Cell
    func setUpCell(index: Int, model: Reviews){
        rating_view.backgroundColor = UIColor.clear
        rating_view.delegate = self
        rating_view.contentMode = UIView.ContentMode.scaleAspectFit
        rating_view.type = .halfRatings
        rating_view.isUserInteractionEnabled = false
        lbl_review.text = model.desc ?? ""
        lbl_name.text = model.name ?? ""
        rating_view.rating = Double(model.rate ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.date(from: model.date!)
        lbl_month.text = "\(convertDateFormater(date: date!, format: "EEEE, dd MMM"))"
    }
    
}

extension NBRatingTableCell: FloatRatingViewDelegate {
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        debugPrint("rating>>",String(format: "%.2f", self.rating_view.rating))
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        debugPrint("rating>>",String(format: "%.2f", self.rating_view.rating))
    }
    
}
