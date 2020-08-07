//
//  ChangePasswordViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnSave              : UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    var txtCurrentPassword                  : CustomTextField!
    var txtNewPassword                      : CustomTextField!
    var txtReNewPassword                    : CustomTextField!
    var strCurrentPassword                  : String            = ""
    var strNewPassword                      : String            = ""
    var strReNewPassword                    : String            = ""
    var arrayPlaceHolder                    : [String]          = []
    var isChangePasswordSuccess             : Bool              = false
    //end
    
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    //end
    
    //MARK: - Set Up View
    func setup(){
        self.tableView.estimatedRowHeight = 80
        self.tableView.register(UINib(nibName: "TextWithBGTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithBGTableViewCell")
        self.lblHeader.text = "CHANGE_PASSWORD_HEADER".localized()
        self.arrayPlaceHolder = ["OLD_PASSWORD".localized(),
                                 "NEW_PASSWORD".localized(),
                                 "CONFIRM_PASSWORD".localized()]
        self.btnSave.setTitle("SAVE".localized(), for: .normal)
    }
    //end
    
    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        var error : (Bool, String) = (false, "")
        if(self.txtCurrentPassword.text == ""){
            error = (false, "PASSWORD_EMPTY".localized())
        }else if(self.txtCurrentPassword.text!.count < 6){
            error = (false, "PASSWORD_INVALID".localized())
        }else if(self.txtNewPassword.text == ""){
            error = (false, "PASSWORD_EMPTY".localized())
        }else if(self.txtReNewPassword.text!.count < 6){
            error = (false, "PASSWORD_INVALID".localized())
        }else if(self.txtReNewPassword.text == ""){
            error = (false, "PASSWORD_EMPTY".localized())
        }else if(self.txtCurrentPassword.text!.count < 6){
            error = (false, "PASSWORD_INVALID".localized())
        }else if (self.txtNewPassword.text != self.txtReNewPassword.text){
            error = (false, "SAME_PASSWORD_INVALID".localized())
        }else{
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
    @IBAction func btnSaveTapped(_ sender: Any) {
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
            self.callChangePasswordApi(currentPassword: self.strCurrentPassword, newPassword: self.strNewPassword, confirmPassword: self.strReNewPassword)
        }else{
            self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableView Delegate, DataSource and Function
extension ChangePasswordViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPlaceHolder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
        cell.txtField.isSecureTextEntry = true
        cell.txtField.setLeftPaddingPoints(10)
        cell.txtField.setPlaceholder(placeholder: self.arrayPlaceHolder[indexPath.row], color: UIColor(named: "Placeholder_Light_Blue_Color"))
        
        if indexPath.row == 0{
            self.txtCurrentPassword = cell.txtField
        }else if indexPath.row == 1{
            self.txtNewPassword = cell.txtField
        }else{
            self.txtReNewPassword = cell.txtField
        }
        cell.txtField.delegate = self
        
        return cell
    }
}

/**
 MARK: - Extension LoginVC of UITextFieldDelegate
 */
extension ChangePasswordViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtCurrentPassword{
            self.strCurrentPassword = textField.text!
        }else if textField == self.txtNewPassword{
            self.strNewPassword = textField.text!
        }else{
            self.strReNewPassword = textField.text!
        }
    }
}
//end

/**
 MARK: - Extension ChangePasswordViewController of AlertDelegate
 */
extension ChangePasswordViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isChangePasswordSuccess{
            self.isChangePasswordSuccess = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func alertCancelTapped() {
        
    }
    
}
//end
