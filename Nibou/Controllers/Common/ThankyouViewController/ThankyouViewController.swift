//
//  ThankyouViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 21/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ThankyouViewController: UIViewController {

    //MARK: - Properties
    
    @IBOutlet weak var btnOKay: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    //end
    
    //MARK: - UIVIewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblDesc.text = "THANK_YOU_DESC".localized()
        self.lblHeader.text = "THANK_YOU_TITLE".localized()
        self.btnOKay.setTitle("CONTINUE".localized(), for: .normal)
        // Do any additional setup after loading the view.
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
    @IBAction func btnOkTapped(_ sender: Any) {
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
