//
//  NBRatingsVC.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class NBRatingsVC: BaseViewController {

    @IBOutlet weak var btn_back         : UIButton!
    @IBOutlet weak var lbl_header       : UILabel!
    @IBOutlet weak var lbl_NoData       : UILabel!
    @IBOutlet weak var table_view       : UITableView!
    var expertId                        : String         = ""
    var arrayReview                     : [Reviews]      = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.setup()
        self.callGetListOfReviewsAPI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.table_view.estimatedRowHeight = 200
        self.table_view.rowHeight = UITableView.automaticDimension
        self.table_view.register(UINib(nibName: "NBRatingTableCell", bundle: nil), forCellReuseIdentifier: "NBRatingTableCell")
        self.lbl_NoData.text = "NO_DATA_FOUND".localized()
        self.lbl_header.text = "REVIEWS_HEADER".localized()
    }

    func setUpModel(model: ReviewModel){
        var reviewModel = Reviews()
        if model.data != nil{
            if model.data!.count > 0{
                for subModel in model.data!{
                    reviewModel.rate = subModel.attributes!.value!
                    reviewModel.desc = subModel.attributes!.comment!
                    reviewModel.date = subModel.attributes!.created_at!
                    reviewModel.senderId = subModel.relationships!.customer!.data!.id!
                    self.arrayReview.append(reviewModel)
                }
            }
        }
        if self.arrayReview.count > 0{
            self.lbl_NoData.isHidden = true
            for i in 0...self.arrayReview.count - 1{
                var mainModel = self.arrayReview[i]
                if model.included != nil{
                    if model.included!.count > 0{
                        for subModel in model.included!{
                            if subModel.id! == mainModel.senderId!{
                                mainModel.name = subModel.attributes!.username!
                            }
                        }
                        self.arrayReview[i] = mainModel
                    }
                }
            }
        }else{
            self.lbl_NoData.isHidden = false
        }
        self.table_view.reloadData()
    }
    
    
    @IBAction func btn_backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Extension of UITableView Delegate and DataSource
extension NBRatingsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayReview.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "NBRatingTableCell", for: indexPath) as! NBRatingTableCell
        cell.setUpCell(index: indexPath.row, model: self.arrayReview[indexPath.row])
        cell.selectionStyle = .none
        self.table_view.separatorColor = UIColor.clear
        self.table_view.tableFooterView = UIView()
        return cell
    }
}

