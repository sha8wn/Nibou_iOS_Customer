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
    @IBOutlet weak var btnBack                  : UIButton!
    @IBOutlet weak var btnFindNewExpert         : UIButton!
    var searchExpertProfileData                 : ExpertProfileModel!
    var arrayOfPreviousExpertProfileData        : [ExpertProfileData]  = []
    var selectedSuverArray                      : [String]             = []
    var isOpenFrom                              : SurveyOpenFrom!
    var roomId                                  : String!              = ""
    var isSelected                              : Bool                 = false
    var expertId                                : String               = ""
    
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
        
        self.lblStaticHeader.text = "CHOOSE_EXPERT_HEADER".localized()
        self.lblStaticChooseExpert.text = "CHOOSE_PREVIOUS_EXPERT".localized()
//        self.btnFindNewExpert.setTitle("SPEAK_TO_NEW_EXPERT".localized(), for: .normal)
        
        let buttonAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Bold", size: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        
        let newExpertAttributedString = NSAttributedString(string: "SPEAK_TO_NEW_EXPERT".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        
        
        self.btnFindNewExpert.titleLabel?.textAlignment = .center
        self.btnFindNewExpert.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnFindNewExpert.setAttributedTitle(newExpertAttributedString, for: .normal)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFindNewExpertTapped(_ sender: Any) {
        if self.searchExpertProfileData != nil{
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "ExpertProfileViewController") as! ExpertProfileViewController
            viewController.profileModel = self.searchExpertProfileData
            viewController.selectedSuverArray = self.selectedSuverArray
            viewController.roomId = self.roomId
            viewController.isOpenFrom = self.isOpenFrom
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            self.showAlert(viewController: self, alertTitle: "EXPERT_UNAVAIBALE".localized(), alertMessage: "ALL_EXPERT_OFFLINE".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
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
        cell.expertProfileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if imageUrl != ""{
            cell.expertProfileImageView.sd_setImage(with: URL(string: kBaseURL + imageUrl), placeholderImage: UIImage(named: "profile_icon_iPhone"), options: .highPriority, completed: nil)
        }else{
            cell.expertProfileImageView.image = UIImage(named: "profile_icon_iPhone")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: ExpertProfileData = self.arrayOfPreviousExpertProfileData[indexPath.row]
        if self.isOpenFrom == .switchExpert{
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "CopyExpertChatViewController") as! CopyExpertChatViewController
            viewController.roomId = self.roomId
            viewController.expertId = model.id ?? ""
            viewController.isComeFrom = .switchExpert
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            if getChatRoomCreatedFirstTime() == true{
                let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "CopyExpertChatViewController") as! CopyExpertChatViewController
                viewController.expertId = model.id ?? ""
                viewController.selectedSuverArray = self.selectedSuverArray
                viewController.isComeFrom = .other
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                self.expertId = model.id!
                self.callChatSessionApi(expertId: self.expertId, arrayExtersie: self.selectedSuverArray)
            }
        }
    }
}

extension ChooseExpertViewController: AlertDelegate{
    
    func alertOkTapped() {
//        if self.isSelected{
//            self.isSelected = false
//            self.callChatSessionApi(expertId: self.expertId, arrayExtersie: self.selectedSuverArray)
//        }
    }
    
    func alertCancelTapped() {
        
    }
}
