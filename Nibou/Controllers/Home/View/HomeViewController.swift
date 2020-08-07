//
//  HomeViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var btnFindExpert        : UIButton!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblTitle             : UILabel!
    @IBOutlet weak var lblDesc              : UILabel!
    @IBOutlet weak var lblStaticIssue       : UILabel!
    var homeModel                           : HomeModel!
    var cardModel                           : [CardIncluded]!
    var haveValidCard                       : Bool              = false
    var selectedIndex                       : Int               = 0
    
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotificationHandler(notification:)), name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionEndNotificationHandler(notification:)), name: Notification.Name("ChatRoom_Session_End"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newMessageNotificationHandler(notification:)), name: Notification.Name("NEW_MESSAGE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotificationHandler(notification:)), name: Notification.Name("RELOAD_HOME_DATA"), object: nil)
        self.tabBarController?.tabBar.isHidden = false
        self.setup()
        self.callGetChatSessionApi()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChatRoom_Session_End"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RELOAD_HOME_DATA"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("NEW_MESSAGE"), object: nil)
    }

    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        let profileModel = getProfileModel()
        
        if profileModel != nil{
            self.lblTitle.text = String(format: "HOME_TITLE".localized(),  profileModel!.data!.attributes!.name!)
        }
        self.lblDesc.text = "HOME_DESC".localized()
        self.lblStaticIssue.text = "TALK_ABOUT_DIFF_ISSUE".localized()
    }
    //end

    @objc func sessionEndNotificationHandler(notification: Notification) {
        self.tabBarController?.tabBar.isHidden = false
        self.setup()
        self.callGetChatSessionApi()
    }

    @objc func reloadDataNotificationHandler(notification: Notification) {
        self.tabBarController?.tabBar.isHidden = false
        self.setup()
        self.callGetChatSessionApi()
    }
    
    @objc func newMessageNotificationHandler(notification: Notification) {
        self.updateListOnNewMessage()
    }
    
    func updateListOnNewMessage(){
        DispatchQueue.main.async {
            var arrayNewMessage = getNewMessageData()
            arrayNewMessage.sort{ ($0["newMessageCount"] as! Int) > ($1["newMessageCount"] as! Int) }
            print(arrayNewMessage)
            for newMessageDict in arrayNewMessage{
                if self.homeModel != nil{
                    if self.homeModel.data!.count > 0{
                        for i in 0...self.homeModel.data!.count - 1{
                            var model = self.homeModel.data![i]
                            print(model)
                            if model.id! == newMessageDict["roomId"] as! String{
                                model.newMessageCount = newMessageDict["newMessageCount"] as? Int
                                model.lastMessageTimestamp = newMessageDict["lastMessageTimestamp"] as? String
                                self.homeModel.data![i] = model
                            }else{
                            }
                        }
                    }else{
                    }
                }else{
                }
            }
            if self.homeModel != nil{
                if self.homeModel.data!.count > 0{
                    self.homeModel.data!.sort{ (($0 as HomeData).lastMessageTimestamp ?? "") > (($1 as HomeData).lastMessageTimestamp ?? "") }
                }
            }
            self.tableView.reloadData()
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
    @IBAction func btnFIndExpertTapped(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = true
        let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
        viewController.isOpenFrom = .home
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK: - UITableView Delegate and DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.homeModel != nil{
            return self.homeModel.data!.count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        var title: String = ""
        if self.homeModel != nil{
            let model = self.homeModel.data![indexPath.row]
            cell.newMessageView.layer.cornerRadius = cell.newMessageView.frame.height/2
            if model.newMessageCount ?? 0 > 0{
                cell.newMessageView.isHidden = false
                cell.lblMessageCount.text = "\(model.newMessageCount!)"
            }else{
                cell.newMessageView.isHidden = true
            }
            
            if let _ = model.attributes!.expertises{
                for i in 0...model.attributes!.expertises!.count - 1{
                    let subModel = model.attributes!.expertises![i]
                    if model.attributes!.expertises!.count > 1{
                        if i == 0{
                            title = subModel.data!.attributes!.title!
                        }else{
                            title = title + "\n\n" + subModel.data!.attributes!.title!
                        }
                    }else{
                        title = subModel.data!.attributes!.title!
                    }
                }
            }else{
            }
        }
        cell.lblTitle.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if self.haveValidCard == true{
            let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "NBChatVC") as! NBChatVC
            self.tabBarController?.tabBar.isHidden  = true
            if self.homeModel != nil{
                let model = self.homeModel.data![indexPath.row]
                chatVC.homeDataModel = model
            }
            chatVC.isOpenFrom = .home
            self.navigationController?.pushViewController(chatVC, animated: true)
        }else{
            let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
            cardVC.cardDelegate = self
            cardVC.isComeFrom = "Home"
            self.present(cardVC, animated: true, completion: nil)
        }
    }
}

extension HomeViewController: AlertDelegate{
    
}

extension HomeViewController: CardAddedSuccessfullyDelegate{
    func cardAdded() {
        let chatVC = mainStoryboard.instantiateViewController(withIdentifier: "NBChatVC") as! NBChatVC
        self.tabBarController?.tabBar.isHidden  = true
        if self.homeModel != nil{
            let model = self.homeModel.data![self.selectedIndex]
            chatVC.homeDataModel = model
        }
        chatVC.isOpenFrom = .home
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
