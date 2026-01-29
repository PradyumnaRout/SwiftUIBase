//
//  Date+Extension.swift
//  MVVMBaseProject
//  Created by hb on 31/07/23.

import Foundation

extension DateFormatter {
    static let customFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    static func dateDifference(_ from: Date, _ to: Date, _ interval: Calendar.Component) -> DateComponents {
        return Calendar.current.dateComponents([interval], from: from, to: to)
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    static func changeDaysBy(years: Int) -> Date {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = years
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)!
    }
    
    /**
     Method which convert string date to timeAgo formate
     
     - parameter PostDate:    date on which you want to perform
     - parameter dateFormate: date foramte like(yyyy-MM-DD hh:mm:ss, ect)
     
     - returns: time ago string
     **/
    static func timeAgoString(PostDate: String, dateFormate: String) -> String {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = dateFormate
        dateFormat.isLenient = false
        dateFormat.timeZone = TimeZone(abbreviation: "GMT")
        dateFormat.locale = Locale.init(identifier: "en_US_POSIX")
        let ExpDate = dateFormat.date(from: PostDate)!
        let calendar = NSCalendar.current
        let components = (calendar as NSCalendar).components([.weekOfYear, .second, .minute, .hour, .day, .month, .year], from: ExpDate, to: Date(), options: [])
        var time: String = ""
        if components.year != nil && components.year! > 0 {
            if components.year == 1 {
                time = "\(Int(components.year!)) year"
            } else {
                time = "\(Int(components.year!)) years"
            }
        } else if components.month != nil && components.month! > 0 {
            if components.month == 1 {
                time = "\(Int(components.month!)) month"
            } else {
                time = "\(Int(components.month!)) months"
            }
        } else if components.weekOfYear != nil && components.weekOfYear! > 0 {
            if components.weekOfYear == 1 {
                time = "\(Int(components.weekOfYear!)) week"
            } else {
                time = "\(Int(components.weekOfYear!)) weeks"
            }
        } else if components.day != nil && components.day! > 0 {
            if components.day == 1 {
                time = "\(Int(components.day!)) day"
            } else {
                time = "\(Int(components.day!)) days"
            }
        } else if components.hour != nil && components.hour! > 0 {
            if components.hour == 1 {
                time = "\(Int(components.hour!)) hour"
            } else {
                time = "\(Int(components.hour!)) hours"
            }
        } else if components.minute != nil && components.minute! > 0 {
            if components.minute == 1 {
                time = "\(Int(components.minute!)) min"
            } else {
                time = "\(Int(components.minute!)) mins"
            }
        } else if components.second != nil {
            if components.second! >= 0 {
                if components.second == 0 {
                    time = "1 sec"
                } else {
                    time = "\(Int(components.second!)) secs"
                }
            } else if components.second! < 0 {
                return "just now"
            }
        }
        return "\(time) ago"
    }
    
    
    static func stringToDate(strDate: String?, format: String) -> Date {
        if let date = strDate, date.count > 0 {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = format
            dateFormat.timeZone = TimeZone(abbreviation: "GMT")
            dateFormat.locale = Locale.init(identifier: "en_US_POSIX")
            return dateFormat.date(from: date)!
        } else {
            return Date()
        }
    }
    static func stringToTime (strTime: String?, format: String) -> Date {
        
        if let date = strTime, date.count > 0 {
            let inFormatter = DateFormatter()
            //            inFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
            //            inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            inFormatter.dateFormat = "hh:mm a"
            return inFormatter.date(from: date)!
        } else {
            return Date()
        }
    }
    static func dateToString(date: Date?, format: String) -> String {
        if let dateToConvert = date {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = format
            //            dateFormat.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
            //            dateFormat.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            return dateFormat.string(from: dateToConvert)
        } else {
            return ""
        }
    }
    
    static func stringToString(strSourceDate: String?, srcFormat: String, destFormat: String, utcToLocal: Bool? = true) -> String {
        if let strToConvert = strSourceDate {
            let dateFormat = DateFormatter()
            if utcToLocal == true {
                dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            }
            dateFormat.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            dateFormat.dateFormat = srcFormat
            if let date = dateFormat.date(from: strToConvert) {
                dateFormat.dateFormat = destFormat
                dateFormat.timeZone = TimeZone.current
                return dateFormat.string(from: date)
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
}

extension TimeZone {
    static func utcOffset() -> String {
        
        let seconds = TimeZone.current.secondsFromGMT()
        let hours = seconds/3600
        let minutes = abs(seconds/60) % 60
        let tz = String(format: "%+.2d:%.2d", hours, minutes)
        return tz
//        if let abbreviation = TimeZone.current.abbreviation() {
//            return abbreviation.replacingOccurrences(of: "GMT", with: "")
//        }
//        return ""
    }
}
