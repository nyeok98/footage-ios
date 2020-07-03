//
//  DateConverter.swift
//  footage
//
//  Created by Wootae on 6/29/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation

class DateConverter {
    static func stringToDate(int: Int, start: Bool) -> Date {
        var string: String = String(int)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        switch string.count {
        case 4: // 2020
            if start { string = string + "0101" } // return 20200101
            else { string = string + "1231" } // return 20201231
            break
        case 6: // 202006
            if start { string = string + "01" } // return 20200601
            else {
                if int % 10 == 2 { // February
                    if (int / 100) % 4 == 0 { string = string + "29" } // leap year
                    else { string = string + "28" }
                } else if [1, 3, 5, 7, 8, 10, 12].contains(int % 10) {
                    string = string + "31"
                } else { string = string + "30" }
            }
            break
        default: break
        }
        if start { return dateFormatter.date(from: string) ?? Date() } // return 20200616 00:00
        else { return Date(timeInterval: 86400, since: dateFormatter.date(from: string) ?? Date()) }
        // return 20200616 23:59
    }
    
    static func dateToDay(date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return Int(dateFormatter.string(from: date))!
    }
    
    static func dateToMonth(date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return Int(dateFormatter.string(from: date))!
    }
    
    static func dateToYear(date: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return Int(dateFormatter.string(from: date))!
    }
    
    static func lastMondaySunday() -> (Int, Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let oneDay = -86400
        var monday = 0
        var sunday = 0
        switch dateFormatter.string(from: Date()) {
        case "Monday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 7)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 1)))
        case "Tuesday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 8)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 2)))
        case "Wednesday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 9)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 3)))
        case "Thursday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 10)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 4)))
        case "Friday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 11)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 5)))
        case "Saturday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 12)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 6)))
        case "Sunday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 13)))
            sunday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 7)))
        default:
            break
        }
        return (monday, sunday)
    }
}
