//
//  ChooseUserTypeViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class ChooseUserTypeViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet weak var btnNewUser           : UIButton!
    @IBOutlet weak var btnReturningUser     : UIButton!
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    //end

    /**
     MARK: - Set Up View
    */
    func setup(){
        self.btnNewUser.layer.cornerRadius = 8
        self.btnNewUser.layer.borderWidth = 1
        self.btnNewUser.layer.borderColor = UIColor.white.cgColor
        
        self.btnReturningUser.layer.cornerRadius = 8
        self.btnReturningUser.layer.borderWidth = 1
        self.btnReturningUser.layer.borderColor = UIColor.white.cgColor
        
        self.btnNewUser.setTitle("NEW_USER".localized(), for: .normal)
        self.btnReturningUser.setTitle("RETURNING_USER".localized(), for: .normal)
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
    @IBAction func btnNewUserTapped(_ sender: Any) {
        let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnReturningUser(_ sender: Any) {
        let viewController = loginAndSignupStoryboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
