//
//  FeedbackViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 17/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var txtSubject           : CustomTextField!
    @IBOutlet weak var txtMessage           : UITextView!
    @IBOutlet weak var lblHeader            : UILabel!
    @IBOutlet weak var btnSubmit            : UIButton!
    @IBOutlet weak var btnBack              : UIButton!
    var isAddedSuccesfully                  : Bool               = false
    //end
    
    
    //MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Set Up View
    func setup(){
        self.txtSubject.setLeftPaddingPoints(10)
        self.txtSubject.setPlaceholder(placeholder: "ENTER_SUBJECT_FEEDBACK".localized(), color: UIColor(named: "Placeholder_Light_Blue_Color"))
        self.txtMessage.delegate = self
        self.txtMessage.text = "ENTER_FEEDBACK".localized()
        self.txtMessage.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
        self.txtMessage.textContainer.lineFragmentPadding = 10
        self.lblHeader.text = "FEEDBACK".localized()
        self.btnSubmit.setTitle("SUBMIT_FEEDBACK".localized(), for: .normal)
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

    @IBAction func btnSubmitFeedbackTapped(_ sender: Any) {
        self.view.endEditing(true)
        if self.txtSubject.text != ""{
            if self.txtMessage.text != nil{
                self.callUpdateFeedbackApi(subject: self.txtSubject.text!, message: self.txtMessage.text)
            }else{
                self.showAlert(viewController: self,alertTitle: "ERROR".localized(), alertMessage: "EMPTY_FEEDBACK".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
            }
        }else{
            self.showAlert(viewController: self,alertTitle: "ERROR".localized(), alertMessage: "EMPTY_SUBJECT_FEEDBACK".localized(), alertType: .oneButton, singleButtonTitle: "OK".localized())
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: UITextView Delegate
extension FeedbackViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "Placeholder_Light_Blue_Color") {
            textView.text = nil
            textView.textColor = UIColor(named: "Blue_Color")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "ENTER_FEEDBACK".localized()
            textView.textColor = UIColor(named: "Placeholder_Light_Blue_Color")
        }
    }
}

extension FeedbackViewController: AlertDelegate{
    func alertOkTapped() {
        if self.isAddedSuccesfully{
            self.isAddedSuccesfully = false
            self.navigationController?.popViewController(animated: true)
        }
    }
}
