//
//  Date.swift
//  Freddy
//
//  Created by C100-107 on 01/06/19.
//  Copyright © 2019 C100-107. All rights reserved.
//

import Foundation
let defaultDateFormat = "0000-00-00 00:00:00"
let REQUESTED_TIME_FORMATE = "dd MMM hh:mm a"
let TIME_FORMATE = "HH:mm:ss"
extension Date {
	
    init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = Scanner(string: jsonDate)
        
        // Check prefix:
        guard scanner.scanString(prefix, into: nil)  else { return nil }
        
        // Read milliseconds part:
        var milliseconds : Int64 = 0
        guard scanner.scanInt64(&milliseconds) else { return nil }
        // Milliseconds to seconds:
        var timeStamp = TimeInterval(milliseconds)/1000.0
        
        // Read optional timezone part:
        var timeZoneOffset : Int = 0
        if scanner.scanInt(&timeZoneOffset) {
            let hours = timeZoneOffset / 100
            let minutes = timeZoneOffset % 100
            // Adjust timestamp according to timezone:
            timeStamp += TimeInterval(3600 * hours + 60 * minutes)
        }
        
        // Check suffix:
        guard scanner.scanString(suffix, into: nil) else { return nil }
        
        // Success! Create NSDate and return.
        self.init(timeIntervalSince1970: timeStamp)
    }
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    public func timeAgoSinceDate(numericDates:Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let currentDate = self
        return dateFormatter.string(from: currentDate)
        
    }
	func daySuffix() -> String {
		let calendar = Calendar.current
		let dayOfMonth = calendar.component(.day, from: self)
		switch dayOfMonth {
		case 1, 21, 31: return "st"
		case 2, 22: return "nd"
		case 3, 23: return "rd"
		default: return "th"
		}
	}
    func localToUTC(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dt = dateFormatter.date(from: self.toString(format: format))
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return dateFormatter.string(from: dt!)
    }
    
    func UTCtoLocal(format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: self.toString(format: format))
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: dt!)
    }
    
//    func toString (format: String = "yyyy-MM-dd HH:mm:ss") -> String? {
//        return DateFormatter(format: format).string(from: self)
//    }
    
//    func timeAgo() -> String? {
//        let date: Date? = self
//        let units:Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
//        var components: DateComponents? = nil
//        if let aDate = date {
//            components = Calendar.current.dateComponents(units, from: aDate, to: Date())
//        }
//
//        var strTimeAgo: String?
//
//        if (components?.year ?? 0) > 0 {
//            strTimeAgo = date?.toString(format: "yyyy-MM-dd")
//        } else if (components?.month ?? 0) > 0 {
//            strTimeAgo = date?.toString(format: "MM-dd HH:mm")
//        } else if (components?.weekOfYear ?? 0) > 0 {
//            strTimeAgo = date?.toString(format: "MM-dd HH:mm")
//        } else if (components?.day ?? 0) > 0 {
//            strTimeAgo = date?.toString(format: "MM-dd HH:mm")
//        } else if (components?.hour ?? 0 >= 1) {
//            strTimeAgo = date?.toString(format: "HH:mm")
//        } else if (components?.minute ?? 0 >= 1) {
//            strTimeAgo = "\(Int(components?.minute ?? 0)) m ago"
//        } else if (components?.second ?? 0 >= 10) {
//            strTimeAgo = "\(Int(components?.second ?? 0)) s ago"
//        } else {
//            strTimeAgo = "Just now"
//        }
//
//        return strTimeAgo
//    }
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
    /// Returns the amount of minutes from another date
        func minutes(from date: Date) -> Int {
            return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
        }
    
    /// Returns the amount of seconds from another date
        func seconds(from date: Date) -> Int {
            return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        }
    
    
}
extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
    
    func timeAgo() -> String? {
        
        let date = self.toDate()
        
        let units:Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        var components: DateComponents? = nil
        if let aDate = date {
            components = Calendar.current.dateComponents(units, from: aDate, to: Date())
        }
        
        var strTimeAgo: String?
        
        if (components?.year ?? 0) > 0 || (components?.month ?? 0) > 0 || (components?.weekOfYear ?? 0) > 0 {
            strTimeAgo = date?.toString(format: "dd-MM-yyyy")
        } else if (components?.day ?? 0) == 1 {
            strTimeAgo = "Yesterday"
        }  else if (components?.day ?? 0) > 0 {
            strTimeAgo = date?.toString(format: "dd/MM/yyyy")
        } else if (components?.hour ?? 0 >= 1) {
            strTimeAgo = date?.toString(format: "h:mm a")
        } else if (components?.minute ?? 0 >= 1) {
            strTimeAgo = "\(Int(components?.minute ?? 0))m ago"
        } else if (components?.second ?? 0 >= 10) {
            strTimeAgo = "\(Int(components?.second ?? 0))s ago"
        } else {
            strTimeAgo = "Just now"
        }
        
        return strTimeAgo
    }
    
    func serverToLocal(date:String) -> Date? {
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormatter.date(from: date)
        return date1
    }

}
