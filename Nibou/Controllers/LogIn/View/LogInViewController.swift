//
//  LogInViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/10/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var txtEmailAddress      : CustomTextField!
    @IBOutlet weak var txtPasword           : CustomTextField!
    @IBOutlet weak var btnLogin             : UIButton!
    @IBOutlet weak var btnForgotPassword    : UIButton!
    var strEmail                            : String                = ""
    var strPassword                         : String                = ""
    var isShowPassword                      : Bool                  = false
//    var isLoginSuccessfully                 : Bool                  = false
    
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    //end

    /**
     MARK: - Set Up View
     */
    func setup(){
        self.btnForgotPassword.setTitle("FORGOT_PASSWORD".localized(), for: .normal)
        self.txtEmailAddress.setPlaceholder(placeholder: "EMAIL_ADDRESS".localized())
        self.txtPasword.setPlaceholder(placeholder: "PASSWORD".localized())
        self.btnLogin.setTitle("LOGIN".localized(), for: .normal)
        self.txtEmailAddress.delegate = self
        self.txtPasword.delegate = self
        self.txtPasword.isSecureTextEntry = true
    }
    //end
    
    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        var error : (Bool, String) = (false, "")
        if(isValidEmail(email: self.txtEmailAddress.text!) == false){
            error = (false, "EMAIL_EMPTY".localized())
        }
        else if(self.txtPasword.text == ""){
            error = (false, "PASSWORD_EMPTY".localized())
        }
        else if(self.strPassword.count < 6){
            error = (false, "PASSWORD_INVALID".localized())
        }
        else{
            error = (true, "")
        }
        return error
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
    @IBAction func btnLoginTapped(_ sender: Any) {
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
            self.callAccessTokenApi(emailAddress: self.strEmail, password: self.strPassword)
        }else{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
        let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnShowHidePasswordTapped(_ sender: Any) {
        if self.isShowPassword{
            self.isShowPassword = false
            self.txtPasword.isSecureTextEntry = true
            self.btnShowHidePassword.setImage(UIImage(named: "ic_Eye"), for: .normal)
        }else{
            self.isShowPassword = true
            self.txtPasword.isSecureTextEntry = false
            self.btnShowHidePassword.setImage(UIImage(named: "ic_Eye_Cross"), for: .normal)
        }
    }
}

/**
 MARK: - Extension LoginVC of UITextFieldDelegate
 */
extension LogInViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEmailAddress{
            self.strEmail = textField.text!
        }else if textField == self.txtPasword{
            self.strPassword = textField.text!
        }else{
            
        }
    }
}
//end

/**
 MARK: - Extension Login of AlertDelegate
 */
extension LogInViewController: AlertDelegate{
    
//    func alertOkTapped() {
//        if self.isLoginSuccessfully{
//            self.isLoginSuccessfully = false
//            self.callSignUpApi(emailAddress: self.strEmailAddress, password: self.strPassword, userName: self.strUserName, alias: self.strAlias, country: self.strCountry, dob: self.strDOB)
//        }
//    }
//
//    func alertCancelTapped() {
//        if self.isLoginSuccessfully{
//            self.isLoginSuccessfully = false
//        }
//    }
}
//end
