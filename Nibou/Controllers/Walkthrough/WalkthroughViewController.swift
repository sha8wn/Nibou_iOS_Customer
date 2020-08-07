//
//  WalkthroughViewController.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit
import SDWebImage

class WalkthroughViewController: BaseViewController {

    /**
     MARK: - Properties
    */
    @IBOutlet var txtViewDesc             : UITextView!
    @IBOutlet var imgView                 : UIImageView!
    @IBOutlet var lblTitle                : UILabel!
    var imageUrl                          : String                      = ""
    var titleStr                          : String                      = ""
    var descStr                           : String                      = ""
    //end
    
    /**
     MARK: - UIViewController Life Cycle
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imgView.image = UIImage(named: imageUrl)
        self.txtViewDesc.textContainerInset = .zero
        self.txtViewDesc.textContainer.lineFragmentPadding = 0
        self.lblTitle.text = titleStr
        self.txtViewDesc.text = descStr
    }
    //end
}

