//
//  SuccessViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/10/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

/**
 Alert Delegate.
 ````
 func alertCancelTapped
 func alertOkTapped
 ````
 */

protocol SuccessViewDelegate {
    func successContinueTapped()
}

extension SuccessViewDelegate{
    func successContinueTapped(){
        
    }
}

class SuccessViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var txtDesc          : UITextView!
    @IBOutlet weak var btnContinue      : UIButton!
    var successDelegate                 : SuccessViewDelegate!
    var descStr                         : String!
    var titleStr                        : String!
    var email                           : String!
    var password                        : String!
    var isComeFrom                      : String!
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - SetUp UI
    /**
     Set Up UI of Success View
     */
    func setUpUI(){
        self.txtDesc.textContainerInset = .zero
        self.txtDesc.textContainer.lineFragmentPadding = 0
        self.lblTitle.text = titleStr
        self.txtDesc.text = descStr
        self.btnContinue.setTitle("CONTINUE", for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnContinueTapped(_ sender: Any) {
        if self.isComeFrom == "Register"{
            self.callAccessTokenApi(emailAddress: self.email ?? "", password: self.password ?? "")
        }else{
            self.successDelegate.successContinueTapped()
        }
    }
    
}

extension SuccessViewController{
    func callAccessTokenApi(emailAddress: String, password: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kAccessToken + "?grant_type=password&client_id=" + kClientId + "&client_secret=" + kClientSecret + "&username=" + emailAddress + "&password=" + password + "&account_type=1"
        
        Network.shared.request(urlPath: urlPath, methods: .post, authType: .basic) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                do {
                    let data = try self.JSONdecoder.decode(LoginModel.self, from: response?.data ?? Data())
                    
                    setAccessTokenModel(model: data)
                    
                    kAppDelegate.setUpWebSocket()
                    
                    self.callSaveDeviceAPI()
                    
                } catch let error {
                    self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertMessage: message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
    
    func callSaveDeviceAPI(){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kSaveDeviceToken
        
        let requestDict = ["devise_id" : kAppDelegate.kdeviceIdValueKey,
                           "firebase_token" : kAppDelegate.kdeviceFCMToken ?? "simulator",
                           "devise_description" : "iOS"
        ]
        Network.shared.request(urlPath: urlPath, methods: .put, authType: .auth, params: requestDict as [String : AnyObject]) { (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                self.successDelegate.successContinueTapped()
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized(), alertMessage: "ERROR_SIGNUP_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}

extension SuccessViewController: AlertDelegate{
    
}
