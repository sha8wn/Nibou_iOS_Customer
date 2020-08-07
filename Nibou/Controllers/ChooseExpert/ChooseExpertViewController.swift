//
//  ChooseExpertViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import SDWebImage

class ChooseExpertViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var lblStaticHeader          : UILabel!
    @IBOutlet weak var lblStaticChooseExpert    : UILabel!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var btnFindNewExpert         : UIButton!
    var searchExpertProfileData                 : ExpertProfileModel!
    var arrayOfPreviousExpertProfileData        : [ExpertProfileData]  = []
    var selectedSuverArray                      : [String]             = []
    var isOpenFrom                              : SurveyOpenFrom!
    var roomId                                  : String!              = ""

    
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    /**
     MARK: - Setup UI
     */
    func setUpView(){
        self.tableView.estimatedRowHeight = 60
        self.tableView.register(UINib(nibName: "ChooseExpertTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseExpertTableViewCell")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnFindNewExpertTapped(_ sender: Any) {
        let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "ExpertProfileViewController") as! ExpertProfileViewController
        viewController.profileModel = self.searchExpertProfileData
        viewController.selectedSuverArray = self.selectedSuverArray
        viewController.roomId = self.roomId
        viewController.isOpenFrom = self.isOpenFrom
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - UITableView Delegate and DataSource
extension ChooseExpertViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrayOfPreviousExpertProfileData.count > 0{
            return self.arrayOfPreviousExpertProfileData.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseExpertTableViewCell", for: indexPath) as! ChooseExpertTableViewCell
        let model: ExpertProfileData = self.arrayOfPreviousExpertProfileData[indexPath.row]
        let imageUrl = model.attributes!.avatar!.url ?? ""
        cell.lblExpertName.text = model.attributes!.name ?? ""
        cell.expertProfileImageView.sd_setShowActivityIndicatorView(true)
        cell.expertProfileImageView.sd_setIndicatorStyle(.gray)
        if imageUrl != ""{
            cell.expertProfileImageView.sd_setImage(with: URL(string: kBaseURL + imageUrl), placeholderImage: UIImage(named: "profile_icon_iPhone"), options: .highPriority, completed: nil)
        }else{
            cell.expertProfileImageView.image = UIImage(named: "profile_icon_iPhone")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isOpenFrom == .switchExpert{
            let model: ExpertProfileData = self.arrayOfPreviousExpertProfileData[indexPath.row]
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "CopyExpertChatViewController") as! CopyExpertChatViewController
            viewController.roomId = self.roomId
            viewController.expertId = model.id ?? ""
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            
            
            
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
