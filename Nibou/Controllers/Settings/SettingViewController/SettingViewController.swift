//
//  SettingViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnLogout            : UIButton!
    var isLogout                            : Bool                = false
    var arrTitle                            : [String]            = []
    var arrImage                            : [String]            = []
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.setup()
        
        if getCurrentLanguage() == "ar"{
            self.view.semanticContentAttribute = .forceRightToLeft
            self.tableView.semanticContentAttribute = .forceRightToLeft
        }else{
            self.view.semanticContentAttribute = .forceLeftToRight
            self.tableView.semanticContentAttribute = .forceLeftToRight
        }
    }
    //end
    
    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 80
        self.tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        self.lblHeader.text = "SETTINGS".localized()
        if kAppDelegate.checkCurrentLanguage(language: kAppDelegate.getLanguage()){
            self.arrTitle = ["EDIT_PROFILE".localized(), "CHANGE_PASSWORD".localized(), "MANAGE_CARD".localized(), "TRANSACTION_HISTORY".localized(), "PRICING_TERMS".localized(), "FEEDBACK".localized()]
            self.arrImage = ["ic_Edit_Profile", "ic_Change_Password", "ic_Manage_Cards", "ic_Transaction_History", "ic_Pricing", "ic_Feedback"]
        }else{
            self.arrTitle = ["EDIT_PROFILE".localized(), "CHANGE_PASSWORD".localized(), "CHOOSE_LANGUAGE".localized(), "MANAGE_CARD".localized(), "TRANSACTION_HISTORY".localized(), "PRICING_TERMS".localized(), "FEEDBACK".localized()]
            self.arrImage = ["ic_Edit_Profile", "ic_Change_Password", "ic_Choose_Language", "ic_Manage_Cards", "ic_Transaction_History", "ic_Pricing", "ic_Feedback"]
        }
    }
    //end

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnLogoutTapped(_ sender: Any) {
        self.isLogout = true
        self.showAlert(viewController: self, alertTitle: "", alertMessage: "LOGOUT_ALERT".localized(), alertType: AlertType.twoButton, okTitleString: "LOGOUT".localized(), cancelTitleString: "CANCEL".localized())
    }

    
}

//MARK: - UITableView Delegate and DataSource
extension SettingViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.lblTitle.text = self.arrTitle[indexPath.row]
        cell.imgView.image = UIImage(named: self.arrImage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if kAppDelegate.checkCurrentLanguage(language: kAppDelegate.getLanguage()){
            if indexPath.row == 0{
                
//                isTextChanges = true
//                
//                self.viewDidLoad()
//                self.viewDidLayoutSubviews()
//                
//                self.viewWillAppear(true)
//                self.viewWillLayoutSubviews()
//                
//                
                let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(profileVC, animated: true)
            }else if indexPath.row == 1{
                let changePasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            }else if indexPath.row == 2{
                let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(cardVC, animated: true)
            }else if indexPath.row == 3{
                let tranactionHistoryVC = mainStoryboard.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
                tranactionHistoryVC.viewType = .month
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(tranactionHistoryVC, animated: true)
            }else if indexPath.row == 4{
                self.tabBarController?.tabBar.isHidden  = true
                self.openWebView(urlString: "terms")
            }else{
                let feedbackVC = mainStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }
        }else{
            if indexPath.row == 0{
                let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(profileVC, animated: true)
            }else if indexPath.row == 1{
                let changePasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(changePasswordVC, animated: true)
            }else if indexPath.row == 2{
                let languageVC = walkthroughStoryboard.instantiateViewController(withIdentifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
                self.tabBarController?.tabBar.isHidden  = true
                languageVC.isComeForm = .setting
                self.navigationController?.pushViewController(languageVC, animated: true)
            }else if indexPath.row == 3{
                let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(cardVC, animated: true)
            }else if indexPath.row == 4{
                let tranactionHistoryVC = mainStoryboard.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(tranactionHistoryVC, animated: true)
            }else if indexPath.row == 5{
                self.tabBarController?.tabBar.isHidden  = true
                self.openWebView(urlString: "terms")
            }else{
                let feedbackVC = mainStoryboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                self.tabBarController?.tabBar.isHidden  = true
                self.navigationController?.pushViewController(feedbackVC, animated: true)
            }
        }
    }
}

// MARK: - AlertDelegate
extension SettingViewController: AlertDelegate{
    func alertCancelTapped(){
        if self.isLogout{
            self.isLogout = false
        }else{
            
        }
    }
    func alertOkTapped(){
        if self.isLogout{
            self.isLogout = false
            self.callLogOutApi()
        }else{
            
        }
    }
}

extension SettingViewController{
    func callLogOutApi(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kLogOut
        let requestDict = ["available": false] as [String : Any]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            
            //Unsubscribe to Socket
            kAppDelegate.notficationChannel.unsubscribe()
            kAppDelegate.webClient.disconnect()
            
            //Clear UserDefault
            clearUserDefault()
            
            //Open Login Screen
            let userTypeVC = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
            self.tabBarController?.tabBar.isHidden  = true
            self.navigationController?.pushViewController(userTypeVC, animated: true)
        }
    }
}
