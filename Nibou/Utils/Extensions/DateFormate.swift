

import Foundation

//func getDateFromTimeStamp(timeStamp: String) -> String {
//    let miliSec = Double(timeStamp) ?? 0.0
//    let takeOffDate = Date(timeIntervalSince1970: (miliSec / 1000))
//    let dateformate = DateFormatter()
//    dateformate.dateFormat = "dd/MM/yy"
//    let dateStr: String = dateformate.string(from: takeOffDate)
//    return dateStr
//}
//
//func getDateAndTimeFromTimeStamp(timeStamp: String) -> String {
//    let miliSec = Double(timeStamp) ?? 0.0
//    let takeOffDate = Date(timeIntervalSince1970: (miliSec / 1000))
//    let dateformate = DateFormatter()
//    dateformate.dateFormat = "dd/MM/yyyy HH:mm:ss"
//    let dateStr: String = dateformate.string(from: takeOffDate)
//    return dateStr
//}

//func getDateFromTimeStampInCard(timeStamp: String) -> String {
//    let miliSec = Double(timeStamp) ?? 0.0
//    let takeOffDate = Date(timeIntervalSince1970: (miliSec / 1000))
//    let dateformate = DateFormatter()
//    dateformate.dateFormat = "MM/yyyy"
//    let dateStr: String = dateformate.string(from: takeOffDate)
//    return dateStr
//}
//

func convertDateFormater(date: Date, format: String? = "yyyy-MM-dd") -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    let date = dateFormatter.string(from: date)
    return UTCToLocal(date: date, fromFormat: format!, toFormat: format!)
//    return date
}




//MARK: - Get Current Time Stamp
func getCurrentTimeStamp() -> String{
    return String(format:"%.0f", NSDate().timeIntervalSince1970 * 1000)
}


func getDateTimeStampAsString(timeStamp: NSNumber) -> String {
    let miliSec = Double(truncating: timeStamp)
    let takeOffDate = Date(timeIntervalSince1970: (miliSec / 1000))
    let dateformate = DateFormatter()
    dateformate.dateFormat = "dd/MM/yy"
    let dateStr: String = dateformate.string(from: takeOffDate)
    return dateStr
}

//end

extension Date {
    
    func calculateMessageTimestampfrom(date : Date) -> (String, Int) {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return (days, difference.day ?? 0) }
        //        if let hour = difference.hour, hour       > 0 { return hours }
        //        if let minute = difference.minute, minute > 0 { return minutes }
        //        if let second = difference.second, second > 0 { return seconds }
        return ("", 0)
    }
    
}

func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = toFormat
    
    return dateFormatter.string(from: dt!)
}
