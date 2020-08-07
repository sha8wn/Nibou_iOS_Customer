//
//  EndSessionPopupView.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/07/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit


class NotificationAlertViewController: BaseViewController {
    
    /**
     MARK: - Properties
     */
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnOkay          : UIButton!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblMessage       : UILabel!
    var messageStr                      : String!
    var titleStr                        : String!
    var okTitleString                   : String!
    var cancelTitleString               : String!
    var notificationType                : NotificationType!
    var notificationData                : [AnyHashable : Any]!
    var notificationModel               : WebSocketNotificationModel!
    
    static let sharedInstance           : NotificationAlertViewController = {
        let instance = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "NotificationAlertViewController") as! NotificationAlertViewController
        return instance
    }()
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.lblMessage.text = self.messageStr
        self.lblTitle.text = self.titleStr
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.notificationType == .sessionTimeout{
             NotificationCenter.default.addObserver(self, selector: #selector(self.sessionEndNotificationHandler(notification:)), name: Notification.Name("ChatRoom_Session_End"), object: nil)
        }else{
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.notificationType == .sessionTimeout{
            NotificationCenter.default.removeObserver(self, name: Notification.Name("ChatRoom_Session_End"), object: nil)
        }else{
            
        }
    }
    
    @objc func sessionEndNotificationHandler(notification: Notification) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK: - SetUp UI
    /**
     Set Up UI of Alery View
     */
    func setUpUI(){
        
        //Set View Layout
        self.bgView.layer.cornerRadius = 8
        
        //Set Custom Title
        if self.okTitleString != nil{
            self.btnOkay.setTitle(self.okTitleString, for: UIControl.State.normal)
        }
        
        if self.cancelTitleString != nil{
            self.btnCancel.setTitle(self.cancelTitleString, for: UIControl.State.normal)
        }
        
        //Shadow
        self.bgView.layer.cornerRadius = 8
        self.bgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.bgView.layer.shadowOffset = .zero
        self.bgView.layer.shadowOpacity = 1.0
        self.bgView.layer.shadowRadius = 2.0
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func btnCancelTapped(_ sender: Any) {
        if self.notificationType == .sessionTimeout{
            self.endSessionAPi(roomId: self.notificationModel!.room!.data!.id!)
        }
    }
    @IBAction func btnOkayTapped(_ sender: Any) {
        if self.notificationType == .sessionTimeout{
            self.callSendMessageAPi(roomId: self.notificationModel!.room!.data!.id!, fileData: nil, fileName: nil, paramsArray: nil, mineType: nil, requestDict: ["text" : "END_SESSION"])
        }
    }
}

extension NotificationAlertViewController: AlertDelegate{
    
}
