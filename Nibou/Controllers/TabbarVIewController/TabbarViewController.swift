//
//  TabbarViewController.swift
//  Nibou
//
//  Created by Himanshu Goyal on 16/05/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().unselectedItemTintColor = FunctionConstants.getInstance().hexStringToUIColor("b5e0e0")
        UITabBar.appearance().tintColor = FunctionConstants.getInstance().hexStringToUIColor("6bc2c2")
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
        self.tabBar.barTintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
