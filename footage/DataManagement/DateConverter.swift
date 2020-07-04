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
}
