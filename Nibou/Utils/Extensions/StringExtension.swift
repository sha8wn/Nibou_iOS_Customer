
import Foundation
import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

// Mark Web Api Param encoded
extension String {
    public func addingPercentEncodingForQueryParameter() -> String? {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$'()*+,;"
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
    
    static func formatCurrency(String: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = NSLocale(localeIdentifier: "id_ID") as Locale?
        let numberFromField =  NSString(string: "\(String)").doubleValue
        let convertCurrency = formatter.string(from: NSNumber(value: numberFromField))
//        let replace = ConvertCurrency?.replacingOccurrences(of: "Rp", with: "Rp ")
        return convertCurrency!
    }
}

extension String {
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
}


extension String{
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}


extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
}

extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
            
            return true
        }
        return false
    }
}


//[.font: UIFont(name: FontName.AvenirRegular, size: 15)!]
func sizeOfString (string: String, height: Double, fontname : String, textSize Size : CGFloat) -> CGSize {
    return NSString(string: string).boundingRect(
        with: CGSize(width: .greatestFiniteMagnitude, height: height),
        options: .usesLineFragmentOrigin,
        attributes: [.font: UIFont(name: fontname, size: Size)!],
        context: nil).size
}

func sizeOfString (string: String, width: Double, fontname : String, textSize Size : CGFloat) -> CGSize {
    return NSString(string: string).boundingRect(
        with: CGSize(width: width, height: .greatestFiniteMagnitude),
        options: .usesLineFragmentOrigin,
        attributes: [.font: UIFont(name: fontname, size: Size)!],
        context: nil).size
}
