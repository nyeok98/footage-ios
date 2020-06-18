//
//  JourneyByMonth.swift
//  footage
//
//  Created by Wootae on 6/20/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import Foundation
import MapKit

class JourneyDataManager { // journey 저장 및 데이터 가공을 담당
    
    static var JourneyByDay: [String: JourneyData] = [:]
    static var JourneyByMonth: [String: JourneyData] = [:]
    static var JourneyByYear: [String: JourneyData] = [:]
    
    static func collectJourneyData(footstep: Footstep) { //
        
        let dateFormatter = DateFormatter()
        let date = footstep.timestamp
        
        dateFormatter.dateFormat = "yyyyMMdd"  // 20200616
        let day = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyyMM" // 202006
        let month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "yyyy" // 2020
        let year = dateFormatter.string(from: date)
        
        if JourneyDataManager.JourneyByDay.keys.contains(day) { // existing record for today already present
            if footstep.isNewStartingPoint {
                JourneyByDay[day]!.footstepArray.append([footstep]) // create new array
                JourneyByMonth[month]!.footstepArray.append([footstep])
                JourneyByYear[year]!.footstepArray.append([footstep])
            } else {
                JourneyByDay[day]!.footstepArray[JourneyByDay[day]!.footstepArray.count - 1].append(footstep)
                JourneyByMonth[month]!.footstepArray[JourneyByMonth[month]!.footstepArray.count - 1].append(footstep)
                JourneyByYear[year]!.footstepArray[JourneyByYear[year]!.footstepArray.count - 1].append(footstep)
            }
            
        } else { // first footstep of the day!!
            JourneyByDay[day] = JourneyData(polylines: [[footstep]], date: day)
            if JourneyDataManager.JourneyByMonth.keys.contains(month) { // not first this month
                JourneyByMonth[month]!.footstepArray.append([footstep])
                JourneyByYear[year]!.footstepArray.append([footstep])
            } else { // first footstep of the month!
                JourneyByMonth[month] = JourneyData(polylines: [[footstep]], date: month)
                if JourneyDataManager.JourneyByYear.keys.contains(year) {
                    JourneyByYear[year]!.footstepArray.append([footstep])
                } else { // first footstep of the year
                    JourneyByYear[year] = JourneyData(polylines: [[footstep]], date: year)
                }
            }
        }
    }
}
