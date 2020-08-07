//
//  Constant.swift
//  Nibou
//
//  Created by Ongraph on 5/8/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

/**
 MARK: - App Constants
 */
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate
let kUserDefault = UserDefaults.standard
let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

/**
 MARK: - Storyboard Constants
 */
let walkthroughStoryboard = UIStoryboard(name: "Walkthrough", bundle: nil)
let loginAndSignupStoryboard = UIStoryboard(name: "LoginAndSignup", bundle: nil)
let commonStoryboard = UIStoryboard(name: "Common", bundle: nil)
let surveyStoryboard = UIStoryboard(name: "Survey", bundle: nil)
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
