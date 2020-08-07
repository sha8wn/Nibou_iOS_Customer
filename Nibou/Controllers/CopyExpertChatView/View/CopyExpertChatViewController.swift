//
//  CopyExpertChatViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 20/06/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

enum CopyExpertChatOpenFrom{
    case switchExpert
    case other
}

class CopyExpertChatViewController: BaseViewController {

    // MARK: - Propertues
    @IBOutlet weak var btnNo        : UIButton!
    @IBOutlet weak var btnYes       : UIButton!
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnBack      : UIButton!
    var roomId                      : String!       = ""
    var expertId                    : String!       = ""
    var selectedSuverArray          : [String]      = []
    var isComeFrom                  : CopyExpertChatOpenFrom!
    //end
    
    // MARK: - UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    /**
     MARK: - Setup UI
     */
    func setUpView(){
        
        
        let buttonAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Bold", size: 16.0),
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        let yesAttributedString = NSAttributedString(string: "PREFERENCE_YES_COPY".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
      
        let noAttributedString = NSAttributedString(string: "PREFERENCE_NO_COPY".localized(), attributes: buttonAttributes as [NSAttributedString.Key : Any])
        

        
        self.btnYes.titleLabel?.textAlignment = .center
        self.btnYes.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnYes.setAttributedTitle(yesAttributedString, for: .normal)
        
        
        self.btnNo.titleLabel?.textAlignment = .center
        self.btnNo.titleLabel?.lineBreakMode = .byCharWrapping
        self.btnNo.setAttributedTitle(noAttributedString, for: .normal)
        
        
        self.lblTitle.text = "COPY_CHAT_HEADER".localized()
//        self.btnYes.setTitle("PREFERENCE_YES_COPY".localized(), for: .normal)
//        self.btnNo.setTitle("PREFERENCE_NO_COPY".localized(), for: .normal)
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
    @IBAction func btnNoTapped(_ sender: Any) {
        if self.isComeFrom == .switchExpert{
            self.callCopyChatApi(expertId: self.expertId, roomId: self.roomId, isPrivate: false)
        }else{
            self.callChatSessionApi(expertId: self.expertId, arrayExtersie: self.selectedSuverArray, isPrivate: false)
        }
    }
    @IBAction func btnYesTapped(_ sender: Any) {
        if self.isComeFrom == .switchExpert{
            self.callCopyChatApi(expertId: self.expertId, roomId: self.roomId, isPrivate: true)
        }else{
            self.callChatSessionApi(expertId: self.expertId, arrayExtersie: self.selectedSuverArray, isPrivate: true)
        }
    }
}

// MARK: - AlertDelegate
extension CopyExpertChatViewController: AlertDelegate{
    
}
