//
//  ChooseLanguageViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

enum ChooseLanguageOpenFrom{
    case setting
    case loading
}

class ChooseLanguageViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var lblChooseLanguageStatic      : UILabel!
    @IBOutlet weak var btnEnglish                   : UIButton!
    @IBOutlet weak var btnArabic                    : UIButton!
    @IBOutlet weak var btnTurkish                   : UIButton!
    @IBOutlet weak var btnBack                      : UIButton!
    var isComeForm                                  : ChooseLanguageOpenFrom!
    //end
    
    /**
     MARK: - UIViewController Life Cycle
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblChooseLanguageStatic.text = "CHOOSE_LANGUAGE_STATIC".localized()
        
        if self.isComeForm == .loading{
            self.btnBack.isHidden = true
        }else{
            self.btnBack.isHidden = false
        }
        
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
    @IBAction func btnEnglishTapped(_ sender: Any) {
        Localize.setCurrentLanguage("en")
        setCurrentLanguage(language: "en")
        self.viewWillAppear(true)
        if self.isComeForm == .setting{
            self.navigationController?.popViewController(animated: true)
        }else{
            let model: LoginModel = getAccessTokenModel()
            if model.accessToken != ""{
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnArabicTapped(_ sender: Any) {
        Localize.setCurrentLanguage("ar")
        
        
        setCurrentLanguage(language: "ar")
     
//        kAppDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
//
        
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
  
        
//        extension UITextField {
//            open override func awakeFromNib() {
//                super.awakeFromNib()
//                if UserDefaults.languageCode == "ar" {
//                    if textAlignment == .natural {
//                        self.textAlignment = .right
//                    }
//                }
//            }
//        }
        
        if self.isComeForm == .setting{
            self.navigationController?.popViewController(animated: true)
        }else{
            let model: LoginModel = getAccessTokenModel()
            if model.accessToken != ""{
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnTurkishTapped(_ sender: Any) {
        Localize.setCurrentLanguage("tr")
        setCurrentLanguage(language: "tr")
        self.viewWillAppear(true)
        if self.isComeForm == .setting{
            self.navigationController?.popViewController(animated: true)
        }else{
            let model: LoginModel = getAccessTokenModel()
            if model.accessToken != ""{
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - UITextfield Language Support
extension UITextField {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if getCurrentLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
                self.setRightPaddingPoints(10)
            }
        }else{
            self.setLeftPaddingPoints(10)
        }
    }
}
//end

//MARK: - UITextView Language Support
extension UITextView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        if getCurrentLanguage() == "ar" {
            if textAlignment == .natural {
                self.textAlignment = .right
            }
        }else{
        }
    }
}
//end


////MARK: - UILabel
////
//var isTextChanges: Bool = false
//
//extension UILabel{
//    override open func awakeFromNib() {
//        if isTextChanges{
//            self.font = UIFont.systemFont(ofSize: self.font.pointSize + 10)
//        }else{
//            self.font = UIFont.systemFont(ofSize: self.font.pointSize)
//        }
//    }
//}
