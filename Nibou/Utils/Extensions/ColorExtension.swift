

import Foundation
import UIKit

extension UIColor {
    
    //MARK: - TextField
    class func textfieldSepratorColor() -> UIColor{
        return UIColor.white.withAlphaComponent(0.6)
    }
    
    //MARK: - Header
    class func headerBlueColor() -> UIColor{
        return UIColor(red:49.0/255.0, green:71.0/255.0 ,blue:99.0/255.0 , alpha:1.0)
    }
    
    class func alertTextFieldBGColor() -> UIColor{
        return UIColor(red:239.0/255.0, green:239.0/255.0 ,blue:239.0/255.0 , alpha:1.0)
    }
    
    class func gradient(from c1: UIColor, to c2: UIColor, withWeight Weight: Int) -> UIColor {
        let size = CGSize(width: CGFloat(Weight), height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let colorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [(c1.cgColor), (c2.cgColor)]
        let gradient: CGGradient = CGGradient(colorsSpace: colorspace, colors: (colors as CFArray), locations: nil)!
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image ?? UIImage())
    }
    class func gradient(from c1: UIColor, to c2: UIColor, withHeight height: Int) -> UIColor {
        let size = CGSize(width: 1, height: CGFloat(height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        let colorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [(c1.cgColor), (c2.cgColor)]
        let gradient: CGGradient = CGGradient(colorsSpace: colorspace, colors: (colors as CFArray), locations: nil)!
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: [])
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image ?? UIImage())
    }
    
}
