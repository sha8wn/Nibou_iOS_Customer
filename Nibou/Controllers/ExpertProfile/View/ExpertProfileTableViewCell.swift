//
//  ExpertProfileTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import SDWebImage

class ExpertProfileTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var lblName              : UILabel!
    @IBOutlet weak var btnOpenPdf           : UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var imgViewProfile       : UIImageView!
    @IBOutlet weak var imgViewOnlineProfile : UIImageView!
    @IBOutlet weak var lblLocation          : UILabel!
    @IBOutlet weak var lblWorkingTime       : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.width / 2
        self.imgViewOnlineProfile.layer.cornerRadius = self.imgViewOnlineProfile.frame.width / 2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWithData(model: ExpertProfileModel){
        
        //Username
        if let userName = model.data!.attributes!.name{
            self.lblName.text = userName
        }else{
            self.lblName.text = ""
        }
        
        
        //Location
        var location: String = ""
        
        
        if let city = model.data!.attributes!.city{
            location = city
        }else{
            location = ""
        }
        
        if let country = model.data!.attributes!.country{
            if location == ""{
                location =  country
            }else{
                location = location + ", " + country
            }
        }else{
            location = location + ""
        }
        
        if let timeZone = model.data!.attributes!.timezone{
            if location == ""{
                location = timeZone
            }else{
                location = location + " - " + timeZone
            }
        }else{
            location = location + ""
        }
       
        self.lblLocation.text = location
        
        //Timings
        
        self.lblWorkingTime.text = ""
        
        
        //DESC

        if let shortBio = model.data!.attributes!.short_bio{
            self.lblDesc.text = shortBio
        }else{
            self.lblDesc.text = ""
        }
        
        //Profile Pic
        var url: String = ""
        if let profilePicURL = model.data!.attributes!.avatar!.url{
            url = kBaseURL + profilePicURL
        }else{
            url = ""
        }
    
        self.imgViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
    
//        self.imgViewProfile.sd_setShowActivityIndicatorView(true)
//        self.imgViewProfile.sd_setIndicatorStyle(.gray)
        if url != ""{
            self.imgViewProfile.sd_setImage(with: URL(string: url), completed: nil)
        }else{
            self.imgViewProfile.image = UIImage(named: "profile_icon_iPhone")
        }
    
        
    }
}
