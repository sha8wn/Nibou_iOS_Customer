//
//  NBRightImageTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 13/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import SDWebImage

class NBRightImageTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var button       : UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.activityIndicator.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(imageURL: String, isDownloaded: Bool, indexPath: IndexPath){
        var url: String = ""
        url = kBaseURL + imageURL
        self.imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray

//        self.imgView.sd_setShowActivityIndicatorView(true)
//        self.imgView.sd_setIndicatorStyle(.gray)
        if url != ""{
            self.imgView.sd_setImage(with: URL(string: url), completed: nil)
        }else{
//            self.imgView.image = UIImage(named: "profile_icon_iPhone")
        }

        if isDownloaded{
            self.button.setImage(nil, for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_Download"), for: .normal)
        }
    }
}
