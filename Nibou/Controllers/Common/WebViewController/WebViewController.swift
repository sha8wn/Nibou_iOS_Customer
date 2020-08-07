//
//  WebViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

protocol WebViewDelegate {
    func btnRightTapped()
}

extension WebViewDelegate {
    func btnRightTapped() {}
}

class WebViewController: BaseViewController, UIWebViewDelegate {

    /*
     MARK: - Properties
    */
    @IBOutlet var btnBack       : UIButton!
    @IBOutlet var btnRight      : UIButton!
    @IBOutlet var lblHeader     : UILabel!
    @IBOutlet var webView       : UIWebView!
    var urlString               : String!
    var delegate                : WebViewDelegate!
    
    //end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.backgroundColor = UIColor.clear
        self.webView.delegate = self
        
        self.btnRight.isHidden = true
        if urlString == "terms" || urlString == "privacy"{
            self.callGetSystemText(endPoint: urlString)
        }else if urlString == "data"{
            self.btnRight.isHidden = false
            self.btnRight.setTitle("AGREE".localized(), for: .normal)
            self.callGetSystemText(endPoint: urlString)
        }else{
            if isValidUrl(urlString: urlString){
                self.showLoader(message: "LOADING".localized())
                let url = URL(string: self.urlString!)
                self.webView.loadRequest(URLRequest(url: url!))
            }else{
                self.showAlert(viewController: self, alertMessage: "SOMETHING_WENT_WRONG".localized(), alertType: .oneButton,singleButtonTitle: "OK".localized())
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        self.hideLoader()
        self.showAlert(viewController: self, alertMessage: error.localizedDescription, alertType: .oneButton,singleButtonTitle: "OK".localized())
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        self.hideLoader()
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
        if urlString == "data"{
            self.dismiss(animated: false, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnRightTapped(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate.btnRightTapped()
        }
    }
}

//MARK: - Extension of CustomPopUpDelegate
/**
 This confirms the delegate function of CustomPopUpDelegate
 */
extension WebViewController: AlertDelegate{
    func alertCancelTapped() {
        self.hideLoader()
    }
    
    func alertOkTapped() {
        self.hideLoader()
    }
}


extension WebViewController{
    func callGetSystemText(endPoint: String){
        self.showLoader(message: "LOADING".localized())
        let urlPath = kBaseURL + kGetSystemText + endPoint
        Network.shared.request(urlPath: urlPath, methods: .get, authType: .auth) {
            (response, message, statusCode, status) in
            self.hideLoader()
            if status == .Success{
                let responseDict = response!.result.value as! NSDictionary
                if let dataDict = responseDict.value(forKey: "data") as? NSDictionary{
                    if let attributeDict = dataDict.value(forKey: "attributes") as? NSDictionary{
                        if let text = attributeDict.value(forKey: "text") as? String{
                            self.webView.loadHTMLString(text, baseURL: nil)
                        }
                    }
                }
            }else{
                self.showAlert(viewController: self, alertMessage:  message!, alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }
    }
}
