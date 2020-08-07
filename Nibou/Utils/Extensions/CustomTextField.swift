//
//  CustomTextField.swift
//  Nibou
//
//  Created by Ongraph on 5/9/19.
//  Copyright © 2019 OnGraph. All rights reserved.
//

import Foundation
import UIKit

class CustomTextField: UITextField{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        customizeTextField()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        customizeTextField()
    }

    func customizeTextField(){
        if self.textColor == UIColor(named: "Blue_Color"){
            
        }else{
            self.textColor = UIColor.white
        }
    }
}


extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue ?? UIColor.textfieldSepratorColor()])
        }
    }
    
    func setPlaceholder(placeholder: String, color: UIColor? = UIColor.textfieldSepratorColor()){
        self.placeholder = placeholder
        self.placeHolderColor = color
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
