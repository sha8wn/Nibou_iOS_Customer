//
//  SignUpViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Foundation

class SignUpViewController: BaseViewController {

    /**
      MARK: - Properties
    */
    @IBOutlet weak var btnBack      : UIButton!
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var btnSignUp    : UIButton!
    var txtUserName                 : CustomTextField!
    var txtAlias                    : CustomTextField!
    var txtEmailAddress             : CustomTextField!
    var txtPassword                 : CustomTextField!
    var txtCountry                  : CustomTextField!
    var txtDOB                      : CustomTextField!
    var strUserName                 : String            = ""
    var strEmailAddress             : String            = ""
    var strAlias                    : String            = ""
    var strPassword                 : String            = ""
    var strCountry                  : String            = ""
    var strDOB                      : String            = ""
    var isPrivacyURL                : Bool              = false
    var isTermsURL                  : Bool              = false
    var isRegisterSuccessfully      : Bool              = false
    var isSecurePassword            : Bool              = true
    var actualSelectedDate          : Date!
    
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    //end
    
    /**
     MARK: - Set Up View
     */
    func setup(){
        
        //LANGUAGE
        self.strCountry = "Turkey".localized()
        
        self.tableView.estimatedRowHeight = 80
        self.btnSignUp.setTitle("SIGN_UP".localized(), for: .normal)
        self.tableView.register(UINib(nibName: "HeaderWithTitleAndDescTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderWithTitleAndDescTableViewCell")
        self.tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        self.tableView.register(UINib(nibName: "TextWithButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "TextWithButtonTableViewCell")
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
        else if(self.strPassword == ""){
            error = (false, "PASSWORD_EMPTY".localized())
        }
        else if(self.strPassword.count < 6){
            error = (false, "PASSWORD_INVALID".localized())
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
    @IBAction func btnSignUpTapped(_ sender: Any) {
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
            self.isRegisterSuccessfully = true
            self.showAlert(viewController: self, alertTitle: "", alertMessage: "SIGN_UP_ALERT_MESSAGE".localized(), alertType: AlertType.twoButton, okTitleString: "SIGN_UP".localized(), cancelTitleString: "CANCEL".localized())
        }else{
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
}

/**
 MARK: - Extension SignUpVC of UITableView
 */
extension SignUpViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableView.automaticDimension
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let headerCell : HeaderWithTitleAndDescTableViewCell = tableView.dequeueReusableCell(
                withIdentifier: "HeaderWithTitleAndDescTableViewCell", for: indexPath) as! HeaderWithTitleAndDescTableViewCell
            
            let attributedString = NSMutableAttributedString(string: "SIGN_UP_HEADER_DESC".localized())
            let linkRange1 = (attributedString.string as NSString).range(of: "TERMS_AND_CONDITIONS".localized())
            attributedString.addAttribute(NSAttributedString.Key.link, value: "terms", range: linkRange1)
            let linkRange2 = (attributedString.string as NSString).range(of: "PRIVACY_POLICY".localized())
            attributedString.addAttribute(NSAttributedString.Key.link, value: "privacy", range: linkRange2)
            
            let linkAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineColor.rawValue): UIColor.white,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.underlineStyle.rawValue): NSUnderlineStyle.single.rawValue
            ]
            
            // textView is a UITextView
            headerCell.lblDesc.textContainerInset = .zero
            headerCell.lblDesc.textContainer.lineFragmentPadding = 0
            headerCell.lblDesc.linkTextAttributes = linkAttributes
            headerCell.lblDesc.attributedText = attributedString
            headerCell.lblDesc.font = UIFont(name: "OpenSans", size: 16.0)
            headerCell.lblDesc.textColor = UIColor.white.withAlphaComponent(0.6)
            headerCell.lblDesc.textAlignment = .left
            headerCell.lblDesc.delegate = self
            headerCell.lblTitle.text = "SIGN_UP_HEADER_TITLE".localized()
            
            return headerCell
        }else{
            if indexPath.row == 0{
                let cell : TextTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                cell.txtField.setPlaceholder(placeholder: "FULL_NAME".localized())
                self.txtUserName = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.text = self.strUserName
                return cell
            }else if indexPath.row == 1{
                let cell : TextWithButtonTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithButtonTableViewCell", for: indexPath) as! TextWithButtonTableViewCell
                cell.txtField.setPlaceholder(placeholder: "ALIAS".localized())
                cell.button.setImage(UIImage(named: "ic_Info"), for: .normal)
                cell.button.tag = indexPath.row
                cell.button.addTarget(self, action: #selector(SignUpViewController.btnTableCellTapped(sender:)), for: .touchUpInside)
                self.txtAlias = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.text = self.strAlias
                return cell
            }else if indexPath.row == 2{
                let cell : TextTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                cell.txtField.setPlaceholder(placeholder: "EMAIL_ADDRESS".localized())
                self.txtEmailAddress = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.text = self.strEmailAddress
                return cell
            }else if indexPath.row == 3{
                let cell : TextWithButtonTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithButtonTableViewCell", for: indexPath) as! TextWithButtonTableViewCell
                cell.txtField.setPlaceholder(placeholder: "PASSWORD".localized())
                cell.button.tag = indexPath.row
                
                if self.isSecurePassword{
                    cell.button.setImage(UIImage(named: "ic_Eye"), for: .normal)
                    cell.txtField.isSecureTextEntry = true
                }else{
                    cell.button.setImage(UIImage(named: "ic_Eye_Cross"), for: .normal)
                    cell.txtField.isSecureTextEntry = false
                }
                cell.button.tag = indexPath.row
                cell.button.addTarget(self, action: #selector(SignUpViewController.btnTableCellTapped(sender:)), for: .touchUpInside)
                self.txtPassword = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.text = self.strPassword
                return cell
            }else if indexPath.row == 4{
                let cell : TextWithButtonTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextWithButtonTableViewCell", for: indexPath) as! TextWithButtonTableViewCell
                cell.txtField.setPlaceholder(placeholder: "COUNTRY".localized())
                cell.button.setImage(UIImage(named: "ic_Info"), for: .normal)
                cell.button.tag = indexPath.row
                cell.button.addTarget(self, action: #selector(SignUpViewController.btnTableCellTapped(sender:)), for: .touchUpInside)
                self.txtCountry = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.isUserInteractionEnabled = false
                cell.txtField.text = self.strCountry
                return cell
            }else{
                let cell : TextTableViewCell = tableView.dequeueReusableCell(
                    withIdentifier: "TextTableViewCell", for: indexPath) as! TextTableViewCell
                cell.txtField.setPlaceholder(placeholder: "DOB".localized())
                cell.txtField.isUserInteractionEnabled = true
                self.txtDOB = cell.txtField
                cell.txtField.delegate = self
                cell.txtField.text = self.strDOB
                cell.txtField.addTarget(self, action: #selector(dobTextFieldEditing(sender:)), for: .editingDidBegin)
                return cell
            }
        }
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 4{
//                self.view.endEditing(true)
//                let countryView = CountrySelectView.shared
//                countryView.barTintColor = .black
//                countryView.displayLanguage = .english
//                countryView.searchBarPlaceholder = "SEARCH".localized()
//                countryView.show()
//                countryView.selectedCountryCallBack = { (countryDic) -> Void in
//                    self.strCountry = "\(countryDic["en"] as! String)"
//                    self.tableView.reloadRows(at: [IndexPath(row: 4, section: 1)], with: .none)
//                }
            }
        }
    }
    
    @objc func dobTextFieldEditing(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        self.actualSelectedDate = sender.date
        self.strDOB = convertDateFormater(date: sender.date)
        self.strDOB = "\(convertDateFormater(date: sender.date, format: "dd-MM-yyyy"))"
        self.txtDOB.text = self.strDOB
//        self.tableView.reloadRows(at: [IndexPath(row: 5, section: 1)], with: .none)
    }
    
//    @objc func openInfoViewOfAlisa(){
//        self.showAlert(viewController: self, alertTitle: "ALIAS".localized() ,alertMessage: "ALIAS_INFO_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
//    }
//
//    @objc func openInfoViewOfCountry(){
//        self.showAlert(viewController: self, alertTitle: "COUNTRY".localized() ,alertMessage: "COUNTRY_INFO_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
//    }

    @objc func btnTableCellTapped(sender: UIButton){
        if sender.tag == 1{
            self.showAlert(viewController: self, alertTitle: "ALIAS".localized() ,alertMessage: "ALIAS_INFO_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }else if sender.tag == 3{
            if self.isSecurePassword{
                self.isSecurePassword = false
            }else{
                self.isSecurePassword = true
            }
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .none)
        }else if sender.tag == 4{
            self.showAlert(viewController: self, alertTitle: "COUNTRY".localized() ,alertMessage: "COUNTRY_INFO_DESC".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    
    func getCellValue(){
        let indexPath1 = IndexPath(row: 0, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath1) as? TextTableViewCell {
            self.txtUserName.text = cell.txtField.text!
        }

        let indexPath2 = IndexPath(row: 1, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath2) as? TextTableViewCell {
            self.txtAlias.text = cell.txtField.text!
        }

        let indexPath3 = IndexPath(row: 2, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath3) as? TextTableViewCell{
            self.txtEmailAddress.text = cell.txtField.text!
        }

        let indexPath4 = IndexPath(row: 3, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath4) as? TextTableViewCell {
            self.txtPassword.text = cell.txtField.text!
        }

        let indexPath5 = IndexPath(row: 4, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath5) as? TextTableViewCell {
            self.txtCountry.text = cell.txtField.text!
        }
        
        let indexPath6 = IndexPath(row: 5, section: 1)
        if let cell = self.tableView.cellForRow(at: indexPath6) as? TextTableViewCell {
            self.txtDOB.text = cell.txtField.text!
        }
    }
}
//end

/**
 MARK: - Extension SignUpVC of AlertDelegate
 */
extension SignUpViewController: AlertDelegate{
    
    func alertOkTapped() {
        if self.isRegisterSuccessfully{
            self.isRegisterSuccessfully = false
            self.callSignUpApi(emailAddress: self.strEmailAddress, password: self.strPassword, userName: self.strUserName, alias: self.strAlias, country: self.strCountry, dob: convertDateFormater(date: self.actualSelectedDate, format: "yyyy-MM-dd'T'hh:mm:ssZ"))
        }
    }
    
    func alertCancelTapped() {
        if self.isRegisterSuccessfully{
            self.isRegisterSuccessfully = false
        }
    }
}
//end

/**
 MARK: - Extension SignUpVC of SuccessViewController
 */
extension SignUpViewController: SuccessViewDelegate{
    func successContinueTapped() {
        let cardVC = mainStoryboard.instantiateViewController(withIdentifier: "ChooseCardViewController") as! ChooseCardViewController
        cardVC.cardDelegate = self
        cardVC.isComeFrom = "Launch"
        self.present(cardVC, animated: true, completion: nil)
    }
}
//end

/**
 MARK: - Extension SignUpVC of CardAddedSuccessfullyDelegate
 */
extension SignUpViewController: CardAddedSuccessfullyDelegate{
    func cardAdded() {
        let viewController = surveyStoryboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
        viewController.isOpenFrom = .register
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

/**
 MARK: - Extension SignUpVC of UITextViewDelegate
 */
extension SignUpViewController: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.openWebView(urlString: URL.absoluteString)
        return false
    }
}
//end

/**
 MARK: - Extension SignUpVC of UITextFieldDelegate
 */
extension SignUpViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtUserName{
            self.strUserName = textField.text!
        }else if textField == self.txtAlias{
            self.strAlias = textField.text!
        }else if textField == self.txtEmailAddress{
            self.strEmailAddress = textField.text!
        }else if textField == self.txtPassword{
            self.strPassword = textField.text!
        }else if textField == self.txtCountry{
            self.strCountry = textField.text!
        }else{
            if self.strDOB == ""{
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                self.actualSelectedDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
                self.strDOB = "\(convertDateFormater(date: self.actualSelectedDate, format: "dd-MM-yyyy"))"
            }
            self.tableView.reloadRows(at: [IndexPath(row: 5, section: 1)], with: .none)
//            self.strDOB = textField.text!
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
