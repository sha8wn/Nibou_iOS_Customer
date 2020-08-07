//
//  ExpertDataTableViewCell.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

/**
 Collection Cell Type Options.
 ````
 case Review
 case Normal
 ````
 */
enum EPCollectionCellType{
    /// It will show review collection cell
    case review
    
    /// It will show normal collection cell
    case normal
    
    /// It will show timing collection cell
    case timings
}
//end

protocol ReviewTappedDelegate {
    func reviewTapped()
}

class ExpertDataTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var collectionLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var btnViewAll       : UIButton!
    var cellType                        : EPCollectionCellType!
    var reviewArray                     : [Reviews] = []
    var dataArray                       : [String] = []
    var timingArray                     : [Timings] = []
    var reviewHeight                    : CGFloat   = 0
    var reviewDelegate                  : ReviewTappedDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "EPCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EPCollectionViewCell")
        self.collectionView.register(UINib(nibName: "EPReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EPReviewCollectionViewCell")
        self.collectionView.register(UINib(nibName: "TimingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TimingsCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(){
        self.collectionView.reloadData()
    }
    
    @IBAction func btnViewAllTapped(sender: UIButton){
        if cellType == .review{
            self.reviewDelegate.reviewTapped()
        }else{
        }
    }
}

//MARK: - UICollectionView Delegate And DataSource
extension ExpertDataTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cellType == .normal{
            return self.dataArray.count
        }else if cellType == .timings{
            return self.timingArray.count
        }else{
            return self.reviewArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .normal{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EPCollectionViewCell", for: indexPath) as! EPCollectionViewCell
            cell.lblTitle.text = dataArray[indexPath.item]
            return cell
        }else if cellType == .timings{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimingsCollectionViewCell", for: indexPath) as! TimingsCollectionViewCell
            let dict = self.timingArray[indexPath.item]
            cell.setUpCell(index: indexPath.item, dict: dict)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EPReviewCollectionViewCell", for: indexPath) as! EPReviewCollectionViewCell
             cell.setUpCell(index: indexPath.item, model: self.reviewArray[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if cellType == .review{
            self.reviewDelegate.reviewTapped()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.cellType == .normal{
            if self.dataArray.count > 0{
                let size = sizeOfString(string: self.dataArray[indexPath.item], height: 50.0, fontname: "Ubuntu", textSize: 15.0)
                return CGSize(width: size.width + 20, height: 50)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }else if self.cellType == .timings{
            if self.timingArray.count > 0{
                let size = sizeOfString(string: self.timingArray[indexPath.item].time ?? "", height: 50.0, fontname: "Ubuntu", textSize: 15.0)
                return CGSize(width: size.width + 20, height: 60)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }else{
            if self.reviewArray.count > 0{
                let size1 = sizeOfString(string: self.reviewArray[indexPath.item].name!, width: Double(self.frame.width), fontname: "Ubuntu-Bold", textSize: 17.0)
                let size2 = sizeOfString(string: self.reviewArray[indexPath.item].desc!, width: Double(self.frame.width) , fontname: "Ubuntu", textSize: 15.0)
                let reviewCellHeight = size1.height + size2.height + 135
//                if reviewHeight < reviewCellHeight{
//                    reviewHeight = reviewCellHeight
//                }
//                self.collectionHeightConstraint.constant = reviewHeight
                self.collectionHeightConstraint.constant = reviewCellHeight
                return CGSize(width: kScreenWidth, height: reviewCellHeight)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//       if self.cellType == .normal{
//            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        }else if self.cellType == .timings{
//            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        }else{
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//    }
}
