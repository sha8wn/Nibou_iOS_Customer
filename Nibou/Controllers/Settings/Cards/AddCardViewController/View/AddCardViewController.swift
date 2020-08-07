//
//  AddCardViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

enum AddCardOpenFrom{
    case chooseCard
    case home
    case register
}

class AddCardViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var cardTypeBGView       : UIView!
    @IBOutlet weak var btnBack              : UIButton!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnAddCard           : UIButton!
    @IBOutlet weak var txtCardNumber        : CustomTextField!
    @IBOutlet weak var imgViewCardType      : UIImageView!
    @IBOutlet weak var txtCardHolderName    : CustomTextField!
    @IBOutlet weak var txtCVV               : CustomTextField!
    @IBOutlet weak var txtExpiryDate        : CustomTextField!
    var openFrom                            : AddCardOpenFrom!
    var cardToken                           : STPToken!
    var strCardType                         : String                = ""
    var strCardLastDigit                    : String                = ""
    var cardStripeId                        : String                = ""
    var customerId                          : String                = ""
    var cardId                              : String                = ""
    var isCardAddedSuccessfully             : Bool                  = false
    var cardDelegate                        : CardAddedSuccessfullyDelegate!
    var isCardImageAviable                  : Bool                  = true
//    let cardType: CreditCardType
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.txtCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    //end

    //MARK: - Set Up View
    func setup(){
        self.txtCardNumber.setLeftPaddingPoints(10)
        self.txtCardHolderName.setLeftPaddingPoints(10)
        self.txtExpiryDate.setLeftPaddingPoints(10)
        self.txtCVV.setLeftPaddingPoints(10)
        self.imgViewCardType.isHidden = true
        self.cardTypeBGView.isHidden = true
        self.txtCardNumber.setPlaceholder(placeholder: "CARD_NUMBER".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.txtCardHolderName.setPlaceholder(placeholder: "CARD_HOLDER_NAME".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.txtExpiryDate.setPlaceholder(placeholder: "EXPIRY".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.txtCVV.setPlaceholder(placeholder: "CVV".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.lblHeader.text = "ADD_CARD_HEADER".localized()
        self.btnAddCard.setTitle("ADD_CREDIT_CARD".localized(), for: .normal)
        
    }
    //end
    
    //MARK: - Validate Form
    private func getValidate() -> (Bool, String){
        var error : (Bool, String) = (false, "")
        if(self.txtCardNumber.text == ""){
            error = (false, "ERROR_ENTER_CARD_NUMBER".localized())
        }
        else if(self.txtCardNumber.text!.count < 17){
            error = (false, "ERROR_ENTER_VALID_CARD_NUMBER".localized())
        }
        else if(self.txtExpiryDate.text == ""){
            error = (false, "ERROR_ENTER_EXPIRY_DATE".localized())
        }
        else if(self.txtCVV.text == ""){
            error = (false, "ERROR_ENTER_CVV".localized())
        }
        else if(self.txtCVV.text!.count > 3){
            error = (false, "ERROR_ENTER_VALID_EXPIRY_DATE".localized())
        }
        else if(self.txtCardHolderName.text == ""){
            error = (false, "ERROR_ENTER_CARD_HOLDER_NAME".localized())
        }
        else{
            error = (true, "")
        }
        return error
    }
    
    func setupStripe(type: String){
        self.showLoader(message: "LOADING".localized())
        let (isValidate, errorMessage) = self.getValidate()
        if isValidate{
            //Configure CARD
            let stripeCardParams = STPCardParams()
            stripeCardParams.number = self.txtCardNumber.text
            let expiryParameters = self.txtExpiryDate.text?.components(separatedBy: "/")
            stripeCardParams.expMonth = UInt(expiryParameters?.first ?? "0") ?? 0
            stripeCardParams.expYear = UInt(expiryParameters?.last ?? "0") ?? 0
            stripeCardParams.cvc = self.txtCVV.text
            
            //Configure Payment
            let config = STPPaymentConfiguration.shared()
            let stpApiClient = STPAPIClient.init(configuration: config)
            stpApiClient.createToken(withCard: stripeCardParams) { (token, error) in
                if error == nil {
                    //Success
                    self.cardToken = token
                    
                    if self.isCardImageAviable == false{
                        self.cardTypeBGView.isHidden = false
                        self.imgViewCardType.isHidden = false
                        self.imgViewCardType.image = self.cardToken.card!.image
                    }
                    
                    self.strCardLastDigit = self.cardToken.card!.last4
                    self.cardStripeId = self.cardToken.stripeID
      
                    self.hideLoader()
                    if type == "Customer"{
                        self.callCreateCustomerAPi(token: token!.tokenId)
                    }else{
//                        self.createPayment(token: token!.tokenId, amount: 100)
                        self.createPayment(token: self.customerId, amount: 100)
                    }
                } else {
                    self.hideLoader()
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: "ERROR_ENTER_VALID_CARD_NUMBER".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }
        }else{
            self.hideLoader()
            self.showAlert(viewController: self, alertTitle: "".localized() ,alertMessage: errorMessage, alertType: .oneButton, singleButtonTitle: "OK".localized())
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
    @IBAction func btnBackTapped(_ sender: Any) {
        if self.openFrom == .chooseCard{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnAddCardTapped(_ sender: Any) {
        self.setupStripe(type: "Customer")
    }
    
}


extension AddCardViewController: UITextFieldDelegate{
    
    @objc func didChangeText(textField:UITextField)
    {
        self.txtCardNumber.text = modifyCreditCardString(creditCardString: textField.text!)
    }
    
    func modifyCreditCardString(creditCardString : String) -> String
    {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        if(arrOfCharacters.count > 0)
        {
            for i in 0...arrOfCharacters.count-1
            {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count)
                {
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    func expDateValidation(dateStr:String) {
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        let enterdYr = Int(dateStr.suffix(2)) ?? 0   // get last two digit from entered string as year
        let enterdMonth = Int(dateStr.prefix(2)) ?? 0  // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        if enterdYr > currentYear
        {
            if (1 ... 12).contains(enterdMonth){
                print("Entered Date Is Right")
            } else
            {
                print("Entered Date Is Wrong")
                self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: "ERROR_ENTER_VALID_CARD_DETAILS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
            
        }else if currentYear == enterdYr {
            if enterdMonth >= currentMonth
            {
                if (1 ... 12).contains(enterdMonth) {
                    print("Entered Date Is Right")
                }else{
                    self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: "ERROR_ENTER_VALID_CARD_DETAILS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
                }
            }else{
                self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: "ERROR_ENTER_VALID_CARD_DETAILS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }else{
            self.showAlert(viewController: self, alertTitle: "ERROR".localized() ,alertMessage: "ERROR_ENTER_VALID_CARD_DETAILS".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let newLength = (textField.text?.count)! + string.count - range.length
        if textField == txtCardNumber{
            let (cardType, cardImage) = checkCardType(cardNumber: textField.text!)
            if cardImage != nil{
                self.cardTypeBGView.isHidden = false
                self.imgViewCardType.isHidden = false
                self.isCardImageAviable = true
                self.imgViewCardType.image = cardImage
            }else{
                self.cardTypeBGView.isHidden = true
                self.imgViewCardType.isHidden = true
                self.isCardImageAviable = false
            }
            return newLength <= 19
        }
        else if textField == txtExpiryDate{
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)
            if string == "" {
                if textField.text?.count == 3
                {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
                return true
            }
            if updatedText.count == 5
            {
                expDateValidation(dateStr:updatedText)
                return updatedText.count <= 5
            } else if updatedText.count > 5
            {
                return updatedText.count <= 5
            } else if updatedText.count == 1{
                if updatedText > "1"{
                    return updatedText.count < 1
                }
            }  else if updatedText.count == 2{   //Prevent user to not enter month more than 12
                if updatedText > "12"{
                    return updatedText.count < 2
                }
            }
            textField.text = updatedText
            if updatedText.count == 2 {
                textField.text = "\(updatedText)/"   //This will add "/" when user enters 2nd digit of month
            }
            return false
        }
        else if textField == txtCVV{
            return newLength <= 3
        }
        return true
    }
}

extension AddCardViewController: STPAddCardViewControllerDelegate{
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print(token)
    }
    
}

extension AddCardViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isCardAddedSuccessfully{
            self.isCardAddedSuccessfully = false
            if self.openFrom == .chooseCard{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.dismiss(animated: false) {
                    self.cardDelegate.cardAdded()
                }
            }
        }
    }
}
