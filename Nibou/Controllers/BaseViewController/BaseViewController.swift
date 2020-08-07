//
//  BaseViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    let JSONdecoder = JSONDecoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        for view in self.view.subviews {
//            
//            print("VIEW \(view)")
//            
//            if (view is UILabel) {
//                if isTextChanges{
//                    (view as? UILabel)?.font = UIFont(name: "Apple Color Emoji", size: ((view as? UILabel)?.font.pointSize)!)
//                }else{
//                    (view as? UILabel)?.font = UIFont.systemFont(ofSize: ((view as? UILabel)?.font.pointSize)!)
//                }
//            }
//            
//            if (view is UITextField) {
//                if isTextChanges{
//                    (view as? UITextField)?.font = UIFont(name: "Apple Color Emoji", size: ((view as? UITextField)?.font?.pointSize)!)
//                }else{
//                    (view as? UITextField)?.font = UIFont.systemFont(ofSize: ((view as? UITextField)?.font?.pointSize)!)
//                }
//            }
//            
//            if (view is UIButton) {
//                if isTextChanges{
//                    (view as? UIButton)?.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: ((view as? UIButton)?.titleLabel?.font.pointSize)!)
//                }else{
//                    (view as? UIButton)?.titleLabel?.font = UIFont.systemFont(ofSize: ((view as? UIButton)?.titleLabel?.font.pointSize)!)
//                }
//            }
//        }
    }
    
    
    //MARK: - Show Custom Alert
    /**
     This function will add a PopUp Screen on UIViewController
     - Parameter viewController: In this needs to pass UIViewController on which you want to add ServerError Screen as subview
     - Parameter okTitleString: Pass String, This will set title of Alert
     - Parameter alertMessage: Pass Custom Alert Message
     - Parameter alertType: Pass PopUpType, This will customize popUp with number of Button. We have two type i.e one and two button
     - Parameter okTitleString: Pass String, This will set title of Okay Button
     - Parameter cancelTitleString: Pass String, This will set title of Cancel Button
     - Parameter singleButtonTitle: Pass String, This will set title of Single Button
     */
    
    func showAlert(viewController: UIViewController, alertTitle: String? = "" ,alertMessage: String? = "", alertType: AlertType, okTitleString: String? = "", cancelTitleString: String? = "", singleButtonTitle: String? = ""){
        let alertViewC = commonStoryboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewC.alertDelegate = viewController as? AlertDelegate
        alertViewC.titleStr = alertTitle
        alertViewC.messageStr = alertMessage
        alertViewC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertViewC.alertType = alertType
        alertViewC.okTitleString = okTitleString
        alertViewC.cancelTitleString = cancelTitleString
        alertViewC.singleButtonString = singleButtonTitle
        viewController.present(alertViewC, animated: false, completion: nil)
    }

    //MARK: - Show Custom Alert
    /**
     This function will add a PopUp Screen on UIViewController
     - Parameter viewController: In this needs to pass UIViewController on which you want to add ServerError Screen as subview
     - Parameter okTitleString: Pass String, This will set title of Alert
     - Parameter alertMessage: Pass Custom Alert Message
     - Parameter alertType: Pass PopUpType, This will customize popUp with number of Button. We have two type i.e one and two button
     - Parameter okTitleString: Pass String, This will set title of Okay Button
     - Parameter cancelTitleString: Pass String, This will set title of Cancel Button
     - Parameter singleButtonTitle: Pass String, This will set title of Single Button
     */
    
    func showAlert(viewController: UIViewController, alertTitle: String? = "" ,alertMessage: String, alertType: AlertType, okTitleString: String? = "", cancelTitleString: String? = "", singleButtonTitle: String? = ""){
        let alertViewC = commonStoryboard.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        alertViewC.alertDelegate = viewController as? AlertDelegate
        alertViewC.titleStr = alertTitle
        alertViewC.messageStr = alertMessage
        alertViewC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertViewC.alertType = alertType
        alertViewC.okTitleString = okTitleString
        alertViewC.cancelTitleString = cancelTitleString
        alertViewC.singleButtonString = singleButtonTitle
        viewController.present(alertViewC, animated: false, completion: nil)
    }
    
    /**
     MARK: - Show the loader
    */
    func showLoader(message: String?){
        DispatchQueue.main.async {
            let messageStr = message ?? ""
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = messageStr
            hud.isUserInteractionEnabled = true
        }
    }
 
    /**
     MARK: - Hide the loader
     */
    func hideLoader(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    //MARK: - WebView
    /**
     This function used to open webview screen
     */
    func openWebView(urlString: String? = ""){
        let viewController = commonStoryboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        viewController.urlString = urlString
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - Show Success Screen
    /**
     This function will show a Success Screen on UIViewController
     - Parameter viewController: In this needs to pass UIViewController on which you want to add ServerError Screen as subview
     - Parameter title: Pass String, This will set title of Success Screen
     - Parameter desc: Pass String, This will set Desc of Success Screen
     */
    
    func showSuccessView(viewController: UIViewController, title: String? = "", desc: String, email: String? = "", password: String? = ""){
        let successViewC = commonStoryboard.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        successViewC.successDelegate = viewController as? SuccessViewDelegate
        successViewC.titleStr = title
        successViewC.descStr = desc
        successViewC.email = email
        successViewC.password = password
        successViewC.isComeFrom = "Register"
        viewController.navigationController?.pushViewController(successViewC, animated: true)
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
