//
//  ProfileViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var lblHeader    : UILabel!
    @IBOutlet weak var btnSave      : UIButton!
    @IBOutlet weak var btnBack      : UIButton!
    var txtUserName                 : CustomTextField!
    var txtAlias                    : CustomTextField!
    var txtEmailAddress             : CustomTextField!
    var txtCountry                  : CustomTextField!
    var txtDOB                      : CustomTextField!
    var strUserName                 : String            = ""
    var strEmailAddress             : String            = ""
    var strAlias                    : String            = ""
    var strCountry                  : String            = ""
    var strDOB                      : String            = ""
    var arrayPlaceHolder            : [String]          = []
    var isEditSuccessfully          : Bool              = false
    //end
    
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
        self.callGetProfileApi()
    }
    //end
    
    //MARK: - Set Up View
    func setup(){
        
        //LANGUAGE
        self.strCountry = "Turkey".localized()
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.register(UINib(nibName: "TextWithBGTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithBGTableViewCell")
        self.lblHeader.text = "PROFILE".localized()
        self.arrayPlaceHolder = ["FULL_NAME".localized(), "ALIAS".localized(), "EMAIL_ADDRESS".localized(), "COUNTRY".localized(), "DOB".localized()]
        self.btnSave.setTitle("SAVE".localized(), for: .normal)
    }
    //end

    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        self.getCellValue()
        var error : (Bool, String) = (false, "")
        if(self.strUserName == ""){
            error = (false, "USER_NAME_EMPTY".localized())
        }
        else if(self.strAlias == ""){
            error = (false, "ALIAS_EMPTY".localized())
        }
        else if(isValidEmail(email: self.strEmailAddress) == false){
            error = (false, "EMAIL_EMPTY".localized())
        }
        else if(self.strCountry == ""){
            error = (false, "COUNTRY_EMPTY".localized())
        }
        else if(self.strDOB == ""){
            error = (false, "DOB_EMPTY".localized())
        }
        else{
            error = (true, "")
        }
        return error
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
    @IBAction func btnSaveTapped(_ sender: Any) {
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
            self.callUpdateProfileApi(userName: self.strUserName, country: self.strCountry)
        }else{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITableView Delegate, DataSource and Function
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayPlaceHolder.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextWithBGTableViewCell", for: indexPath) as! TextWithBGTableViewCell
        cell.txtField.setLeftPaddingPoints(10)
        cell.txtField.setPlaceholder(placeholder: self.arrayPlaceHolder[indexPath.row], color: UIColor(named: "Placeholder_Light_Blue_Color"))
        cell.txtField.isUserInteractionEnabled = true
        cell.txtField.alpha = 1.0
        if indexPath.row == 0{
            cell.txtField.text = strUserName
            self.txtUserName = cell.txtField
            cell.txtField.delegate = self
            if getCurrentLanguage() == "ar" {
                cell.txtField.setRightPaddingPoints(10)
            }else{
                cell.txtField.setLeftPaddingPoints(10)
            }
        }else if indexPath.row == 1{
            cell.txtField.isUserInteractionEnabled = false
            cell.txtField.alpha = 0.5
            cell.txtField.text = strAlias
            self.txtAlias = cell.txtField
            cell.txtField.delegate = self
            if getCurrentLanguage() == "ar" {
                cell.txtField.setRightPaddingPoints(10)
            }else{
                cell.txtField.setLeftPaddingPoints(10)
            }
        }else if indexPath.row == 2{
            cell.txtField.isUserInteractionEnabled = false
            cell.txtField.alpha = 0.5
            cell.txtField.text = strEmailAddress
            self.txtEmailAddress = cell.txtField
            cell.txtField.delegate = self
            if getCurrentLanguage() == "ar" {
                cell.txtField.setRightPaddingPoints(10)
            }else{
                cell.txtField.setLeftPaddingPoints(10)
            }
        }else if indexPath.row == 3{
            cell.txtField.isUserInteractionEnabled = false
            cell.txtField.text = strCountry
            self.txtCountry = cell.txtField
            cell.txtField.delegate = self
            if getCurrentLanguage() == "ar" {
                cell.txtField.setRightPaddingPoints(10)
            }else{
                cell.txtField.setLeftPaddingPoints(10)
            }
        }else{
            cell.txtField.isUserInteractionEnabled = false
            cell.txtField.alpha = 0.5
            cell.txtField.text = strDOB
            self.txtDOB = cell.txtField
            cell.txtField.delegate = self
            if getCurrentLanguage() == "ar" {
                cell.txtField.setRightPaddingPoints(10)
            }else{
                cell.txtField.setLeftPaddingPoints(10)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
//            self.view.endEditing(true)
//            let countryView = CountrySelectView.shared
//            countryView.barTintColor = .black
//            countryView.displayLanguage = .english
//            countryView.searchBarPlaceholder = "SEARCH".localized()
//            countryView.show()
//            countryView.selectedCountryCallBack = { (countryDic) -> Void in
//                self.strCountry = "\(countryDic["en"] as! String)"
//                self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
//            }
        }
    }
    
    func getCellValue(){
        let indexPath1 = IndexPath(row: 0, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath1) as? TextTableViewCell {
            self.txtUserName.text = cell.txtField.text!
        }
        
        let indexPath2 = IndexPath(row: 1, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath2) as? TextTableViewCell {
            self.txtAlias.text = cell.txtField.text!
        }
        
        let indexPath3 = IndexPath(row: 2, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath3) as? TextTableViewCell{
            self.txtEmailAddress.text = cell.txtField.text!
        }
        
        let indexPath4 = IndexPath(row: 3, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath4) as? TextTableViewCell {
            self.txtCountry.text = cell.txtField.text!
        }
        
        let indexPath5 = IndexPath(row: 4, section: 0)
        if let cell = self.tableView.cellForRow(at: indexPath5) as? TextTableViewCell {
            self.txtDOB.text = cell.txtField.text!
        }
    }
}

/**
 MARK: - Extension ProfileViewController of AlertDelegate
 */
extension ProfileViewController: AlertDelegate{
    
    func alertOkTapped() {
        if self.isEditSuccessfully{
            self.isEditSuccessfully = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func alertCancelTapped() {
        if self.isEditSuccessfully{
            self.isEditSuccessfully = false
            
        }
    }
}
//end

/**
 MARK: - ProfileViewController of UITextFieldDelegate
 */
extension ProfileViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtUserName{
            self.strUserName = textField.text!
        }else if textField == self.txtAlias{
            self.strAlias = textField.text!
        }else if textField == self.txtEmailAddress{
            self.strEmailAddress = textField.text!
        }else if textField == self.txtCountry{
            self.strCountry = textField.text!
        }else{
            self.strDOB = textField.text!
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        let newLength = (textField.text?.count)! + string.count - range.length
        if(textField == self.txtUserName){
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            
            if alphabet == false{
                return false
            }else{
                return true
            }
        }
        return true
    }
}
//end
