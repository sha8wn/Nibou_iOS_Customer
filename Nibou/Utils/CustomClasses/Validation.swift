
import Foundation
import UIKit

func isValidEmail(email:String) -> Bool {
    
    let emailRegEx = "[a-zA-Z0-9][a-zA-Z0-9\\.\\_\\-\\!\\#\\$\\'\\*\\+\\=\\?\\^\\`\\{\\}\\~\\/]{0,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
    ")+"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidMobile(Mobile:String) -> Bool{
    let RegEx = "^[0-9]{10,16}$"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Mobile)
}


func isValidMobileForCountryCode(mobileNumber: String) -> Bool{
    if mobileNumber.prefix(2) == "62"{
        return false
    }else if mobileNumber.prefix(3) == "062"{
        return false
    }else{
        return true
    }
}



func checkMobileNumber(Mobile:String) -> Bool{
    let RegEx = "^0*$"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: Mobile)
}

func isValidName(name: String) -> Bool{
    let RegEx = "[a-zA-Z\\s]+"
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return Test.evaluate(with: name)
}


func trimString(str: String) -> String{
    return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}

func isNumeric(string: String) -> Bool
{
    let RegEx = "^[0-9]*$"
    let test = NSPredicate(format:"SELF MATCHES %@", RegEx)
    return test.evaluate(with: string)
}

func isValidUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = URL(string: urlString) {
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}

func checkCardType(cardNumber: String) -> (String, UIImage?){
    
    let amexRegex = "^3[47][0-9]{0,}$"
    let visaRegex = "^4[0-9]{0,}$"
    let masterCardRegex = "^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[01]|2720)[0-9]{0,}$"
    let maestroRegex = "^(5[06789]|6)[0-9]{0,}$"
    let dinersRegex = "^3(?:0[0-59]{1}|[689])[0-9]{0,}$"
    let discoverRegex = "^(6011|65|64[4-9]|62212[6-9]|6221[3-9]|622[2-8]|6229[01]|62292[0-5])[0-9]{0,}$"
    let jcbRegex = "^(?:2131|1800|35)[0-9]{0,}$"
    let unionPayRegex = "^(62|88)[0-9]{5,}$"
    let hiperCardRegex = "^(606282|3841)[0-9]{5,}$"
    let eloRegex = "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"

    
    let amexTest = NSPredicate(format:"SELF MATCHES %@", amexRegex)
    let visaTest = NSPredicate(format:"SELF MATCHES %@", visaRegex)
    let masterCardTest = NSPredicate(format:"SELF MATCHES %@", masterCardRegex)
    let maestroText = NSPredicate(format:"SELF MATCHES %@", maestroRegex)
    let dinersTest = NSPredicate(format:"SELF MATCHES %@", dinersRegex)
    let discoverTest = NSPredicate(format:"SELF MATCHES %@", discoverRegex)
    let jcbText = NSPredicate(format:"SELF MATCHES %@", jcbRegex)
    let unionPayText = NSPredicate(format:"SELF MATCHES %@", unionPayRegex)
    let hiperCardText = NSPredicate(format:"SELF MATCHES %@", hiperCardRegex)
    let eloText = NSPredicate(format:"SELF MATCHES %@", eloRegex)

    
    let strCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
    
    var brand = "unknown"
    var image = UIImage(named: "")
    if (amexTest.evaluate(with: strCardNumber)) {
        brand = "AMEX"
        image = UIImage(named: "ic_Amex")
    } else if (visaTest.evaluate(with: strCardNumber)) {
        brand = "VISA"
        image = UIImage(named: "ic_Visa")
    } else if (masterCardTest.evaluate(with: strCardNumber)) {
        brand = "MASTER CARD"
        image = UIImage(named: "ic_MasterCard")
    } else if (dinersTest.evaluate(with: strCardNumber)) {
        brand = "DINERS"
        image = nil
    } else if (discoverTest.evaluate(with: strCardNumber)) {
        brand = "DISCOVER"
        image = UIImage(named: "ic_Discover")
    } else if (jcbText.evaluate(with: strCardNumber)) {
        brand = "JCB"
        image = nil
    } else if (unionPayText.evaluate(with: strCardNumber)) {
        brand = "UNION PAY"
        image = nil
    } else if (hiperCardText.evaluate(with: strCardNumber)) {
        brand = "HIPER CARD"
        image = nil
    } else if (eloText.evaluate(with: strCardNumber)) {
        brand = "ELO"
        image = nil
    } else if (maestroText.evaluate(with: strCardNumber)) {
        brand = "MAESTRO"
        image = nil
    }else {
        brand = "unknown"
        image = nil
    }
    return (brand, image ?? nil)
}
