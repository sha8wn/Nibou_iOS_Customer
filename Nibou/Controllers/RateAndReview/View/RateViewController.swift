//
//  RateViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit


class RateViewController: BaseViewController {

    //MARK: - Properties
    
    @IBOutlet weak var lblHeader        : UILabel!
    @IBOutlet weak var txtViewReview    : UITextView!
    @IBOutlet weak var rateView         : FloatRatingView!
    @IBOutlet weak var btnAddReview     : UIButton!
    @IBOutlet weak var btnBack          : UIButton!
    @IBOutlet weak var btnSkip          : UIButton!
    var roomId                          : String                = ""
    var expertId                        : Int                   = 0
    var expertName                      : String                = ""
    var isError                         : Bool                  = false
    
//    var notificationModel               : WebSocketNotificationModel!
    
    //end
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.btnBack.isHidden = true
        self.txtViewReview.delegate = self
        self.txtViewReview.text = "RATE_ENTER_REVIEW".localized()
        self.txtViewReview.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
        self.txtViewReview.textContainer.lineFragmentPadding = 10
        self.rateView.minRating = 0
        self.rateView.type = .wholeRatings
        self.lblHeader.text = String(format: "RATE_HEADER".localized(), self.expertName)
        self.btnSkip.setTitle("SKIP".localized(), for: .normal)
        self.btnAddReview.setTitle("ADD_REVIEW".localized(), for: .normal)
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

    @IBAction func btnAddReviewTapped(_ sender: Any) {
        
        if self.txtViewReview.textColor == UIColor(named: "Placeholder_Light_Blue_Color"){
            self.txtViewReview.text = ""
        }
        let rateValue = Int(self.rateView.rating)
        if rateValue > 0{
            self.callRateApi(roomId: self.roomId, expertId: self.expertId, comment: self.txtViewReview.text, rate: rateValue)
        }else{
            self.showAlert(viewController: self, alertMessage: "ERROR_SELECT_RATING".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
        
    }
    
    @IBAction func btnSkipTapped(_ sender: Any) {
//        self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false) {
            let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController: TabbarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            kAppDelegate.window?.rootViewController = navigationController
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
//        self.dismiss(animated: false, completion: nil)
        
        self.dismiss(animated: false) {
            let navigationController: UINavigationController = walkthroughStoryboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController: TabbarViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
            navigationController.viewControllers = [rootViewController]
            navigationController.navigationBar.isHidden = true
            kAppDelegate.window?.rootViewController = navigationController
        }
        
    }
}

extension RateViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Placeholder_Light_Blue_Color") {
            textView.text = nil
            textView.textColor = UIColor(named: "Blue_Color")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "RATE_ENTER_REVIEW".localized()
            textView.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
        }
    }
}

extension RateViewController: AlertDelegate{
    func alertOkTapped() {
        if isError{
            self.isError =  false
            self.dismiss(animated: false, completion: {
                let thanksViewC = commonStoryboard.instantiateViewController(withIdentifier: "ThankyouViewController") as! ThankyouViewController
                kAppDelegate.window?.rootViewController?.present(thanksViewC, animated: false, completion: nil)
            })
        }
    }
}
