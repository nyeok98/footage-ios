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
    
    static func lastMondayToday() -> (Int, Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let oneDay = -86400
        var monday = 0
        var today = 0
        switch dateFormatter.string(from: Date()) {
        case "Monday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 0)))
            today = dateToDay(date: Date())
        case "Tuesday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 1)))
            today = dateToDay(date: Date())
        case "Wednesday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 2)))
            today = dateToDay(date: Date())
        case "Thursday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 3)))
            today = dateToDay(date: Date())
        case "Friday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 4)))
            today = dateToDay(date: Date())
        case "Saturday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 5)))
            today = dateToDay(date: Date())
        case "Sunday":
            monday = dateToDay(date: Date(timeIntervalSinceNow: TimeInterval(oneDay * 6)))
            today = dateToDay(date: Date())
        default:
            break
        }
        return (monday, today)
    }
    
    static func tagToMonth(year: Int, tag: Int, start: Bool) -> Int {
        var toReturn = 0
        if tag < 10 {
            toReturn = year * 100 + tag // 202006
        } else {
            toReturn = year * 100 + tag // 202010
        }
        if start { return toReturn * 100 + 1 } // 20200601
        else {
            if tag == 2 { // February
                if (year / 100) % 4 == 0 { return toReturn * 100 + 29 } // leap year
                else { return toReturn * 100 + 28 }
            } else if [1, 3, 5, 7, 8, 10, 12].contains(tag) {
                return toReturn * 100 + 31
            } else { return toReturn * 100 + 30 }
        }
    }
}
