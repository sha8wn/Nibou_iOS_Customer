//
//  ForgotPasswordViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/10/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var btnBack                  : UIButton!
    @IBOutlet weak var lblForgotPasswordStatic  : UILabel!
    @IBOutlet weak var btnResetPassword         : UIButton!
    @IBOutlet weak var txtEmailAddress          : UITextField!
    var isSuccess                               : Bool          =  false
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    /**
     MARK: - Set Up View
     */
    func setup(){
        self.txtEmailAddress.setPlaceholder(placeholder: "EMAIL_ADDRESS".localized())
        self.txtEmailAddress.layer.cornerRadius = 6
        self.txtEmailAddress.setLeftPaddingPoints(10)
        self.btnResetPassword.setTitle("RESET_PASSWORD".localized(), for: .normal)
        self.lblForgotPasswordStatic.text = "RESET_PASSWORD_STATIC_DESC".localized()
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
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetPasswordTapped(_ sender: Any) {
        if self.txtEmailAddress.text == "" || isValidEmail(email: self.txtEmailAddress.text!) == false{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: "EMAIL_EMPTY".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }else{
            self.callForgotPasswordApi(email: self.txtEmailAddress.text!)
        }
    }
}

/**
 MARK: - Extension SignUpVC of UITableView
 */
extension ForgotPasswordViewController: AlertDelegate{
    
    func alertOkTapped() {
        if self.isSuccess == true{
            self.isSuccess = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
//end
