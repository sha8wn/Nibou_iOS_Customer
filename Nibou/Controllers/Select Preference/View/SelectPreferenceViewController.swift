//
//  SelectPreferenceViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/13/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class SelectPreferenceViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblStaticTitle       : UILabel!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var btnOptionA           : UIButton!
    @IBOutlet weak var btnOptionB           : UIButton!
    @IBOutlet weak var btnOptionC           : UIButton!
    var selectedSuverArray                  : [String]      = []
    var loadingScreen                       : LoadingViewController!
    var isOpenFrom                          : SurveyOpenFrom!
    var searchExpertData                    : ExpertProfileModel!
    var roomId                              : String!       = ""
    var expertId_SwitchExpert               : String!       = ""
    var noExpertFound                       : Bool          = false
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.loadingScreen != nil{
            self.hideLoadingScreen(isSuccess: false)
        }
    }
    
    /**
     MARK: - Setup UI
     */
    func setUpView(){
        self.lblStaticTitle.text = "SELECT_PREFERENCE_HEADER".localized()
        
        let buttonAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Bold", size: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        
        let preferenceAAttributedString = NSAttributedString(string: "PREFERENCE_A".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        
        let preferenceBAttributedString = NSAttributedString(string: "PREFERENCE_B".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        
        let preferenceCAttributedString = NSAttributedString(string: "PREFERENCE_C".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        
        self.btnOptionA.titleLabel?.textAlignment = .center
        self.btnOptionA.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnOptionA.setAttributedTitle(preferenceAAttributedString, for: .normal)
        
        self.btnOptionB.titleLabel?.textAlignment = .center
        self.btnOptionB.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnOptionB.setAttributedTitle(preferenceBAttributedString, for: .normal)
        
        self.btnOptionC.titleLabel?.textAlignment = .center
        self.btnOptionC.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnOptionC.setAttributedTitle(preferenceCAttributedString, for: .normal)
        
//        self.btnOptionA.setTitle("PREFERENCE_A".localized(), for: .normal)
//        self.btnOptionB.setTitle("PREFERENCE_B".localized(), for: .normal)
//        self.btnOptionC.setTitle("PREFERENCE_C".localized(), for: .normal)
    }
    
    func showLoadingScreen() {
        self.loadingScreen = commonStoryboard.instantiateViewController(withIdentifier: "LoadingViewController") as? LoadingViewController
        self.view.addSubview(self.loadingScreen.view)
    }

    func hideLoadingScreen(model: ExpertProfileModel? = nil, isSuccess: Bool){
        if isSuccess{
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "ExpertProfileViewController") as! ExpertProfileViewController
            viewController.profileModel = model
            viewController.selectedSuverArray = self.selectedSuverArray
            viewController.isOpenFrom = self.isOpenFrom
            viewController.roomId = self.roomId
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            self.loadingScreen.view.removeFromSuperview()
            
        }
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
    @IBAction func btnOptionATapped(_ sender: Any) {
        self.callSearchExpertApi(surveyArray: self.selectedSuverArray, type: "0")
    }
    @IBAction func btnOptionBTapped(_ sender: Any) {
        self.callSearchExpertApi(surveyArray: self.selectedSuverArray, type: "2")
    }
    @IBAction func btnOptionCTapped(_ sender: Any) {
        self.callSearchExpertApi(surveyArray: self.selectedSuverArray, type: "1")
    }
}

extension SelectPreferenceViewController: AlertDelegate{
    func alertOkTapped() {
        if self.noExpertFound{
            self.noExpertFound = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
