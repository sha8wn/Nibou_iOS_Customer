//
//  LoadingViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 15/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var lblPleaseWait: UILabel!
    @IBOutlet weak var lblPleaseWaitDesc: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblPleaseWait.text = "PLEASE_WAIT_TITLE".localized()
        self.lblPleaseWaitDesc.text = "PLEASE_WAIT_DESC".localized()
        
        // Do any additional setup after loading the view.
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
