//
//  AlertViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

/**
 Alert Type Options.
 ````
 case OneButton
 case TwoButton
 ````
 */
enum AlertType{
    /// It will show one button on Alert View
    case oneButton
    
    /// It will show two button on Alert View
    case twoButton
    
    /// It will show texfield with One button on Alert View
    case textfieldWithOneButton
    
    /// It will show texfield with Two button on Alert View
    case textfieldWithTwoButton
}
//end

/**
 Alert Delegate.
 ````
 func alertCancelTapped
 func alertOkTapped
 ````
 */

protocol AlertDelegate {
    func alertCancelTapped()
    func alertOkTapped()
    func alertOkTextFieldTapped(text: String)
}

extension AlertDelegate{
    func alertCancelTapped(){
        
    }
    func alertOkTapped(){
        
    }
    func alertOkTextFieldTapped(text: String){
        
    }
}

class AlertViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var bgView           : UIView!
    @IBOutlet weak var btnCancel        : UIButton!
    @IBOutlet weak var btnOkay          : UIButton!
    @IBOutlet weak var btnSingle        : UIButton!
    @IBOutlet weak var lblTitle         : UILabel!
    @IBOutlet weak var lblMessage       : UILabel!
    @IBOutlet weak var txtfield         : UITextField!
    var messageStr                      : String!
    var titleStr                        : String!
    var alertType                       : AlertType!
    var alertDelegate                   : AlertDelegate!
    var okTitleString                   : String!
    var cancelTitleString               : String!
    var singleButtonString              : String!
    static let sharedInstance           : AlertViewController = {
        let instance = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
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
    
    //MARK: - SetUp UI
    /**
     Set Up UI of Alery View
     */
    func setUpUI(){
      
        //Set View Layout
        self.bgView.layer.cornerRadius = 8
        
        self.txtfield.setPlaceholder(placeholder: "PLEASE_ENTER".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.txtfield.layer.cornerRadius = 6
        
        //Set One or Two button
        if alertType == AlertType.oneButton{
            self.btnCancel.isHidden = true
            self.btnOkay.isHidden = true
            self.txtfield.isHidden = true
            self.btnSingle.isHidden = false
        }else if alertType == AlertType.twoButton{
            self.btnCancel.isHidden = false
            self.btnOkay.isHidden = false
            self.txtfield.isHidden = true
            self.btnSingle.isHidden = true
        }else if alertType == AlertType.textfieldWithOneButton{
            self.btnCancel.isHidden = true
            self.btnOkay.isHidden = true
            self.txtfield.isHidden = false
            self.btnSingle.isHidden = false
            self.lblMessage.isHidden = true
        }else if alertType == AlertType.textfieldWithTwoButton{
            self.btnCancel.isHidden = false
            self.btnOkay.isHidden = false
            self.txtfield.isHidden = false
            self.btnSingle.isHidden = true
            self.lblMessage.isHidden = true
        }
        
        //Set Custom Title
        if self.okTitleString != nil{
            self.btnOkay.setTitle(self.okTitleString, for: UIControl.State.normal)
        }
        
        if self.cancelTitleString != nil{
            self.btnCancel.setTitle(self.cancelTitleString, for: UIControl.State.normal)
        }
        
        if self.singleButtonString != nil{
            self.btnSingle.setTitle(self.singleButtonString, for: UIControl.State.normal)
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
        self.dismiss(animated: false){
            self.alertDelegate.alertCancelTapped()
        }
    }
    @IBAction func btnOkayTapped(_ sender: Any) {
        if alertType == AlertType.textfieldWithTwoButton{
            self.dismiss(animated: false){
                self.alertDelegate.alertOkTextFieldTapped(text: self.txtfield.text ?? "")
            }
        }else{
            self.dismiss(animated: false){
                self.alertDelegate.alertOkTapped()
            }
        }
    }
    @IBAction func btnSingleTapped(_ sender: Any) {
        if alertType == AlertType.textfieldWithOneButton{
            self.dismiss(animated: false){
                self.alertDelegate.alertOkTextFieldTapped(text: self.txtfield.text ?? "")
            }
        }else{
            self.dismiss(animated: false){
                self.alertDelegate.alertOkTapped()
            }
        }
    }
    
}
