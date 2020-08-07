//
//  LaunchViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 11/09/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import MBProgressHUD

class LaunchViewController: BaseViewController {

    var cardModel           : [CardIncluded]!
    var haveValidCard       : Bool              = false
    var isOpenHome          : Bool              = false
    var willOpen            : String            = ""
    var isError             : Bool              = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let model: LoginModel = getAccessTokenModel()
        if model.accessToken != ""{
            self.callGetChatSessionApi()
        }else{
            self.setUp()
        }
    }
    
    /**
     MARK: - Show the loader
     */
    override func showLoader(message: String?){
        DispatchQueue.main.async {
            let messageStr = message ?? ""
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = messageStr
            hud.isUserInteractionEnabled = true
            hud.offset.y = kScreenHeight / 4
        }
    }
    
    
    func setUp(){
        let model: LoginModel = getAccessTokenModel()

        if self.checkCurrentLanguage(language: self.getLanguage()){
            if getLanguage() != getCurrentLanguage(){
                Localize.setCurrentLanguage(getLanguage())
                setCurrentLanguage(language: getLanguage())
            }

             
//            //Set Turkish As Default
//            Localize.setCurrentLanguage("tr")
//            setCurrentLanguage(language: "tr")

            if model.accessToken != ""{
                self.callSplashScreenApi { (type) in
                    if self.isOpenHome{
                        self.willOpen = "TabbarViewController"
                    }else{
                        self.willOpen = "SurveyViewController"
                    }
                    self.callGetProfileApi()
                }
            }else{
                self.openWalkThroughScreen()
            }
        }else{
            if getCurrentLanguage() != ""{
                if getLanguage() != getCurrentLanguage(){
                    if self.checkCurrentLanguage(language: getLanguage()){
                        Localize.setCurrentLanguage(getLanguage())
                        setCurrentLanguage(language: getLanguage())
                        
//                        //Set Turkish As Default
//                        Localize.setCurrentLanguage("tr")
//                        setCurrentLanguage(language: "tr")
                        
                        if model.accessToken != ""{
                            self.callSplashScreenApi { (type) in
                                if self.isOpenHome{
                                    self.willOpen = "TabbarViewController"
                                }else{
                                    self.willOpen = "SurveyViewController"
                                }
                                self.callGetProfileApi()
                            }
                        }else{
                           self.openWalkThroughScreen()
                        }
                    }else{
                        if model.accessToken != ""{
                            self.callSplashScreenApi { (type) in
                                if self.isOpenHome{
                                    self.willOpen = "TabbarViewController"
                                }else{
                                    self.willOpen = "SurveyViewController"
                                }
                                self.callGetProfileApi()
                            }
                        }else{
                            self.openWalkThroughScreen()
                        }
                    }
                }else{
                    self.openChooseLanguageScreen()
                }
            }else{
                self.openChooseLanguageScreen()
            }
        }
    }
    
    func openChooseLanguageScreen(){
        let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController: ChooseLanguageViewController = walkthroughStoryboard.instantiateViewController(withIdentifier: "ChooseLanguageViewController") as! ChooseLanguageViewController
        rootViewController.isComeForm = .loading
        navigationController.viewControllers = [rootViewController]
        kAppDelegate.window?.rootViewController = navigationController
    }
    
    func openWalkThroughScreen(){
        let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController: UIViewController = walkthroughStoryboard.instantiateViewController(withIdentifier: "WalkthroughParentViewController") as UIViewController
        navigationController.viewControllers = [rootViewController]
        navigationController.navigationBar.isHidden = true
        kAppDelegate.window?.rootViewController = navigationController
    }
    
    /**
     MARK: - Get App Current Language
     - This function is used to get app language
     
     - Returns: Language Code String
     */
    func getLanguage() -> String{
        let prefferedLanguage = Locale.preferredLanguages[0]
        let code = prefferedLanguage.components(separatedBy: "-")
        return code.first ?? Locale.preferredLanguages[0]
    }
    
    /**
     MARK: - Check App Current Language
     - This function is used to check current language and compare that current language is English, Arabic and Turkish or not
     
     - Returns: Bool(Check current language is English, Arabic and Turkish or not)
     */
    func checkCurrentLanguage(language: String) -> Bool{
        if language == "en"{
            return true
        }else if language == "tr"{
            return true
        }else if language == "ar"{
            return true
        }else{
            return false
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

}

extension LaunchViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isError == true
        {
            let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController: ChooseUserTypeViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChooseUserTypeViewController") as! ChooseUserTypeViewController
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            kAppDelegate.window?.rootViewController = navigationController
        }
        else
        {
            self.viewWillAppear(true)
        }
    }
}

extension LaunchViewController: CardAddedSuccessfullyDelegate{
    func cardAdded() {
        let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
        
        if self.willOpen == "TabbarViewController"{
            let rootViewController: TabbarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            kAppDelegate.window?.rootViewController = navigationController
        }else if self.willOpen == "SurveyViewController"{
            let rootViewController: SurveyViewController = surveyStoryboard.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
            rootViewController.isOpenFrom = .appDelegate
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            kAppDelegate.window?.rootViewController = navigationController
        }
    }
}
