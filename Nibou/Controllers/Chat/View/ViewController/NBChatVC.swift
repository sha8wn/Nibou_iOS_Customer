//
//  NBChatVC.swift
//  Nibou
//
//  Created by Ongraph on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit
import DropDown
import RealmSwift

enum ChatOpenFrom{
    case home
    case switchExpert
}

class NBChatVC: BaseViewController {

    //MARK:- Properties
    @IBOutlet weak var lblUserName               : UILabel!
    @IBOutlet weak var imgUserState              : UIImageView!
    @IBOutlet weak var imgProfile                : UIImageView!
    @IBOutlet weak var table_view                : UITableView!
    @IBOutlet weak var btnMore                   : UIButton!
    @IBOutlet weak var textView_message          : UITextView!
    @IBOutlet weak var cons_textViewBottom       : NSLayoutConstraint!
    @IBOutlet weak var cons_heightForBottomView  : NSLayoutConstraint!
    let moreDropDown                                                      = DropDown()
    var webClient                                : ActionCableClient!     = nil
    var roomChannel                              : Channel!               = nil
    var homeDataModel                            : HomeData!
    var expertId                                 : String                 = ""
    var roomId                                   : String                 = ""
    var roomType                                 : String                 = ""
    var imagePicker                              : UIImagePickerController = UIImagePickerController()
    var relamDB                                  : Realm                  = try! Realm()
    var chatModel                                : Results<ChatModel>!
    var previousDayCount                         : Int                    = 0
    var showDateCurrentDay                       : Int                    = 0
    var isOpenFrom                               : ChatOpenFrom!
    var isOfflinePopupOpen                       : Bool                   = false
    var arrayTimings                             : [Timings]              = []
    var isRoomFound                              : Bool                   = true
    var isCardError                              : Bool                   = false
    var isChatEnded                              : Bool                   = false
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.textView_message.returnKeyType = .done
        self.textView_message.inputAccessoryView = UIView()
        self.tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadDataNotificationHandler(notification:)), name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.expertStatusHandlerOffline(notification:)), name: Notification.Name("Expert_Offline"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.expertStatusHandlerOnline(notification:)), name: Notification.Name("Expert_Online"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.sessionEndNotificationHandler(notification:)), name: Notification.Name("ChatRoom_Session_End"), object: nil)
        self.setUp()
        self.setUpHeaderView(model: self.homeDataModel)
        self.setUpTableViewWithData(roomId: self.roomId)
        self.setUpWebSocket(roomId: self.homeDataModel.id!)
//        self.setUpExpertStatus()
//        self.setupNewMessageCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.roomChannel.unsubscribe()
        self.webClient.disconnect()
        self.roomChannel.onUnsubscribed = {
            print("Unsubscibribed to \(self.roomChannel.isSubscribed)")
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChatRoom_Session_End"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("Expert_Offline"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("Expert_Online"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("DEVICE_FOREGROUND"), object: nil)
        
        
        self.setupNewMessageCount()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
    
    
    @objc func reloadDataNotificationHandler(notification: Notification) {
        self.view.endEditing(true)
        self.setUp()
        self.setUpHeaderView(model: self.homeDataModel)
        self.setUpTableViewWithData(roomId: self.roomId)
        self.setUpWebSocket(roomId: self.homeDataModel.id!)
//        self.setUpExpertStatus()
//        self.setupNewMessageCount()
    }
    
    @objc func sessionEndNotificationHandler(notification: Notification) {
        if let data = notification.object as? NSDictionary{
            let sessionEndRoomId = data.value(forKey: "roomId") as! String
            if sessionEndRoomId == self.homeDataModel.id!{
                self.navigationController?.popViewController(animated: true)
            }else{
            }
        }
    }
    
    func setupNewMessageCount() {
        var arrayNewMessage = getNewMessageData()
        var tempArray: [[String: Any]] = []
        if arrayNewMessage.count > 0{
            for i in 0...arrayNewMessage.count - 1{
                var dict = arrayNewMessage[i]
                if dict["roomId"] as! String == self.homeDataModel.id!{
                }else{
                    tempArray.append(dict)
                }
            }
            setNewMessageData(array: tempArray)
        }
    }
    
    //MARK:- Set up
    func setUp(){
        self.table_view.register(UINib(nibName: "NBLeftMessageTableCell", bundle: nil), forCellReuseIdentifier: "NBLeftMessageTableCell")
        self.table_view.register(UINib(nibName: "NBRightMessageTableCell", bundle: nil), forCellReuseIdentifier: "NBRightMessageTableCell")
        self.table_view.register(UINib(nibName: "NBTimeTableCell", bundle: nil), forCellReuseIdentifier: "NBTimeTableCell")
        self.table_view.register(UINib(nibName: "NBLeftImageTableViewCell", bundle: nil), forCellReuseIdentifier: "NBLeftImageTableViewCell")
        self.table_view.register(UINib(nibName: "NBRightImageTableViewCell", bundle: nil), forCellReuseIdentifier: "NBRightImageTableViewCell")
        
        
        let center: NotificationCenter = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(self.keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        let tapGestureKeypad = UITapGestureRecognizer.init(target: self, action: #selector(handleKeypadTapGesture(sender:)))
        table_view.addGestureRecognizer(tapGestureKeypad)
        DispatchQueue.main.async {
            self.textView_message.text = "CHAT_ENTER_MESSAGE".localized()
            self.textView_message.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
            self.scrollToTheBottom(animated: false, position: .bottom)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
    }
    
    @objc func handleKeypadTapGesture(sender : UITapGestureRecognizer)
    {
        textView_message.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = value.cgRectValue.height
        }
        let duration: TimeInterval = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue) ?? 0.4
//        debugPrint("keyboardWillShow >>>",-keyboardHeight)
        self.cons_textViewBottom.constant = -keyboardHeight
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.scrollToTheBottom(animated: false,position: .bottom)
        }

        DispatchQueue.main.async {
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.view.setNeedsUpdateConstraints()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
//        debugPrint("keyboardWillHide")
        guard let userInfo = (notification as Notification).userInfo, let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        self.scrollToTheBottom(animated: false,position: .bottom)
        DispatchQueue.main.async {
            self.cons_textViewBottom.constant = 0
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
                self.view.setNeedsUpdateConstraints()
            }
        }
    }
    
    @objc func keyboardDidChangeFrame(notification: Notification) {
        guard let userInfo = (notification as Notification).userInfo, let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        var keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = value.cgRectValue.height - view.safeAreaInsets.bottom
        } else {
            keyboardHeight = value.cgRectValue.height
        }
        self.scrollToTheBottom(animated: false,position: .bottom)
    }
    
    func setUpDropDown(_ sender: UIButton)
    {
        self.moreDropDown.dataSource = ["VIEW_EXPERT_PROFILE".localized(), "SWITCH_EXPERT".localized(), "END_CONVERSATION".localized()]
        moreDropDown.textFont = UIFont(name: "Ubuntu-Bold", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        moreDropDown.width = 160
        moreDropDown.cellHeight = 50
        moreDropDown.backgroundColor = UIColor.white
        moreDropDown.anchorView = sender
        moreDropDown.cornerRadius = 6
        moreDropDown.bottomOffset =  CGPoint(x: -130, y:(moreDropDown.anchorView?.plainView.bounds.height)!)
        DropDown.appearance().textColor = UIColor(named: "Blue_Color") ?? UIColor.black
        moreDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "ExpertProfileViewController") as! ExpertProfileViewController
                viewController.isProfileOpenFrom = .chat
                let arrayProfile: [ExpertProfileModel] = self.homeDataModel.attributes!.users!
                for i in 0...arrayProfile.count - 1{
                    let profileModel = arrayProfile[i]
                    if profileModel.data!.id! != getLoggedInUserId(){
                        viewController.profileModel = profileModel
                    }
                }
                self.navigationController?.pushViewController(viewController, animated: true)
            }else if index == 1{
                let selectedArray = self.getSelectedSurveyArray(arrayExpertModel: self.homeDataModel.attributes!.expertises ?? [])
                let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "SelectPreferenceViewController") as! SelectPreferenceViewController
                viewController.selectedSuverArray = selectedArray
                viewController.isOpenFrom = .switchExpert
                viewController.roomId = self.roomId
                viewController.expertId_SwitchExpert = self.expertId
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                self.callEndConversionAPI(roomId: self.roomId)
            }
        }
    }
    
    func setUpExpertStatus(){
        
        let model = self.homeDataModel
        
        for i in 0...model!.attributes!.users!.count - 1{
            let subModel = model!.attributes!.users![i]
            if getLoggedInUserId() == subModel.data!.id!{
                //NOT REQUIRED
            }else{
                //Profile Name
                guard let userName = subModel.data!.attributes!.name else{ return }
                self.callGetExpertProfileDataAPI(expertId: subModel.data!.id!, expertName: userName)
            }
        }
    }
    
    
    
    @objc func expertStatusHandlerOffline(notification: Notification) {
        self.imgUserState.image = UIImage(named: "ic_offline")
        self.setUpExpertStatus()
    }
    
    @objc func expertStatusHandlerOnline(notification: Notification) {
        self.imgUserState.image = UIImage(named: "green_icon_iPhone")
        if self.isOfflinePopupOpen == true{
            self.isOfflinePopupOpen = false
            self.dismiss(animated: false, completion: nil)
        }
    }
    
//    @objc func expertStatusHandler(notification: Notification) {
//        self.setUpExpertStatus()
//    }
    
    func getSelectedSurveyArray(arrayExpertModel: [HomeExpertises]) -> [String]{
        var selectedSuverArray: [String] = []
        if arrayExpertModel.count > 0{
            for model in arrayExpertModel{
                selectedSuverArray.append(model.data!.id ?? "")
            }
        }else{
            
        }
        return selectedSuverArray
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK:- Button Action
    @IBAction func btn_backAction(_ sender: Any) {
        if self.isOpenFrom == .switchExpert{
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btn_sendAction(_ sender: Any) {
        if(Reachability.isConnectedToNetwork()){
            let message = trimString(str: self.textView_message.text!)
            if message == "CHAT_ENTER_MESSAGE".localized() || message == ""{
                print("YES: \(message)")
            }else{
                DispatchQueue.main.async {
                    self.textView_message.text = ""
                    self.scrollToTheBottom(animated: false, position: .bottom)
                    self.view.layoutIfNeeded()
                    self.view.layoutSubviews()
                    self.view.setNeedsUpdateConstraints()
                    if self.chatModel != nil && self.chatModel.count > 0{
                        self.updateDataBaseWithTempData(chatId: "\(self.chatModel[0].data.count + 1)", localId: "\(self.chatModel[0].data.count + 1)", message: "\(message)")
                    }else{
                        self.updateDataBaseWithTempData(chatId: "\(self.roomId)", localId: "\(self.roomId)", message: "\(message)")
                    }
                }
                self.callSendMessageAPi(roomId: self.roomId, fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: ["text" : "\(message)"])
            }
        }else{
            self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INTERNET".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
        
        
       
        
        /*
        let queue = DispatchQueue(label: "\(tempChatModel.data.count)", qos: .default)
        queue.async {
            self.callSendMessageAPi(roomId: self.roomId, fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: ["text" : "\(self.textView_message.text!)"], completion: { (result) in
                if result == .Success{
//                    self.tempChatModel.data.remove(at: self.tempChatModel.data.count - 1)
                }else{
                    
                }
            })
        }
         */
    }
    @IBAction func btn_cameraAction(_ sender: Any) {
        if(Reachability.isConnectedToNetwork()){
            //Open Picker
            self.presentImagePicker()
        }else{
            self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "INTERNET".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    @IBAction func btnMoreTapped(_ sender: UIButton) {
        self.setUpDropDown(sender)
        self.moreDropDown.show()
    }
    
}


extension NBChatVC : UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "CHAT_ENTER_MESSAGE".localized(){
            textView.text = ""
            self.textView_message.textColor = UIColor(named: "Blue_Color")
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == "CHAT_ENTER_MESSAGE".localized(){
                textView.text = ""
                self.textView_message.textColor = UIColor(named: "Blue_Color")
            }else{
                
            }
            self.scrollToTheBottom(animated: false, position: .bottom)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == ""{
                textView.text = "CHAT_ENTER_MESSAGE".localized()
                self.textView_message.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
            }else{
                
            }
            self.scrollToTheBottom(animated: false, position: .bottom)
            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.setNeedsUpdateConstraints()
        }
    }
    
    func scrollToTheBottom(animated: Bool, position: UITableView.ScrollPosition)
    {
        let visibleSection = self.table_view.numberOfSections
        print("VISIBLE: \(visibleSection)")
        var numberOfSections = 0
        let numberOfRows = 1
        if self.chatModel != nil && self.chatModel.count > 0{
            let listModel: List<ChatData> = self.chatModel[0].data
            numberOfSections =  listModel.count
            print("TOTAL COUNT: \(numberOfSections)")
            if numberOfSections > 0 && visibleSection > numberOfSections - 1{
                let indexPath = IndexPath(row: numberOfRows - 1, section: visibleSection - 1)
                self.table_view.scrollToRow(at: indexPath as IndexPath, at: position, animated: false)
                
                self.view.layoutIfNeeded()
                self.view.layoutSubviews()
                self.view.setNeedsUpdateConstraints()
            }
        }
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        var temp = ""
        
        if (isBackSpace == -92) {
            if (textView.text! == "") {
            }else{ // backgroud typing
                
                let nsString = textView.text as NSString?
                let newString = nsString?.replacingCharacters(in: range, with: text)
                temp = newString!
                let size = textView_message.contentSize.height
//                debugPrint("temp backword>",size)
                if size > 80{
                    textView_message.isScrollEnabled = true
                }else{
                    textView_message.isScrollEnabled = false
                }
            }
        }
//        else if text == "\n"{
//            self.textView_message.resignFirstResponder()
//        }
        else{ // forward typing
            
            let nsString = textView.text as NSString?
            let newString = nsString?.replacingCharacters(in: range, with: text)
            
            temp = newString!
            
            let size = textView_message.contentSize.height
            debugPrint("temp forword>",size)

            if size > 80{
                textView_message.isScrollEnabled = true
            }else{
                textView_message.isScrollEnabled = false
            }
        }
        
        return true
    }
    
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(self.chatModel[0].data.count)
//        
//    }
    
}

extension NBChatVC: AlertDelegate{
    func alertOkTapped() {
        if self.isOfflinePopupOpen{
            self.isOfflinePopupOpen = false
            
        }else if self.isRoomFound == false{
            self.isRoomFound = true
            self.navigationController?.popViewController(animated: true)
        }else if self.isCardError == true{
            self.isCardError = false
            let addCardVC = mainStoryboard.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
            addCardVC.openFrom = .chooseCard
            self.navigationController?.pushViewController(addCardVC, animated: true)
        }else if self.isChatEnded == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            
        }
    }
    
    func alertCancelTapped() {
        if self.isOfflinePopupOpen{
            self.isOfflinePopupOpen = false
            let selectedArray = self.getSelectedSurveyArray(arrayExpertModel: self.homeDataModel.attributes!.expertises ?? [])
            let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "SelectPreferenceViewController") as! SelectPreferenceViewController
            viewController.selectedSuverArray = selectedArray
            viewController.isOpenFrom = .switchExpert
            viewController.roomId = self.roomId
            viewController.expertId_SwitchExpert = self.expertId
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            
        }
    }
}


